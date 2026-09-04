#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Gemini API Usage
# @raycast.mode fullOutput
# @raycast.packageName Gemini API Usage
# @raycast.icon 📊

# Optional parameters:
# @raycast.description Show Gemini API quota usage across Google Cloud projects

set -u

# Raycast doesn't always inherit your interactive shell's PATH.
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

WINDOW_DAYS=28
QUOTA_TIMEZONE="America/Los_Angeles"

# Format:
#   "Display Name|google-cloud-project-id"
#
# Add as many projects as you want.
PROJECTS=(
  "CLI ENV (default)|gen-lang-client-0689881028"
  "Raycast|gen-lang-client-0774163372"
  "Nimbus|gen-lang-client-0832328198"
)

# NIMBUS_ID="gen-lang-client-0832328198"
# RAYCAST_ID="gen-lang-client-0774163372"
# CLI_ENV_ID="gen-lang-client-0689881028"

# Gemini free-tier Cloud Monitoring metrics.
REQUEST_USAGE_METRIC="generativelanguage.googleapis.com/quota/generate_content_free_tier_requests/usage"
REQUEST_LIMIT_METRIC="generativelanguage.googleapis.com/quota/generate_content_free_tier_requests/limit"
TOKEN_USAGE_METRIC="generativelanguage.googleapis.com/quota/generate_content_free_tier_input_token_count/usage"
TOKEN_LIMIT_METRIC="generativelanguage.googleapis.com/quota/generate_content_free_tier_input_token_count/limit"

# ---------------------------------------------------------------------------
# Dependencies / authentication
# ---------------------------------------------------------------------------

for cmd in gcloud curl jq awk date; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: required command '$cmd' was not found."
    exit 1
  fi
done

TOKEN="$(gcloud auth print-access-token 2>/dev/null)"

if [[ -z "$TOKEN" ]]; then
  echo "Error: unable to obtain a Google Cloud access token."
  echo
  echo "Try:"
  echo "  gcloud auth login"
  exit 1
fi

END_TIME="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
START_TIME="$(date -u -v-"${WINDOW_DAYS}"d +"%Y-%m-%dT%H:%M:%SZ")"

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

query_metric() {
  local project_id="$1"
  local metric="$2"
  local output="$3"

  curl -fsSG \
    -H "Authorization: Bearer $TOKEN" \
    "https://monitoring.googleapis.com/v3/projects/${project_id}/timeSeries" \
    --data-urlencode "filter=metric.type=\"${metric}\"" \
    --data-urlencode "interval.startTime=${START_TIME}" \
    --data-urlencode "interval.endTime=${END_TIME}" \
    --data-urlencode "view=FULL" \
    > "$output"

  if jq -e '.error' "$output" >/dev/null 2>&1; then
    echo "Google Cloud Monitoring error:"
    jq -r '.error.message' "$output"
    return 1
  fi
}

lookup_value() {
  local file="$1"
  local model="$2"

  awk -F $'\t' -v model="$model" '
    $1 == model {
      print $2
      exit
    }
  ' "$file"
}

human_number() {
  local n="$1"

  awk -v n="$n" '
    function clean(v) {
      sub(/0+$/, "", v)
      sub(/\.$/, "", v)
      return v
    }

    BEGIN {
      if (n >= 1000000000) {
        printf "%sB", clean(sprintf("%.2f", n / 1000000000))
      } else if (n >= 1000000) {
        printf "%sM", clean(sprintf("%.2f", n / 1000000))
      } else if (n >= 1000) {
        printf "%sK", clean(sprintf("%.2f", n / 1000))
      } else {
        printf "%d", n
      }
    }
  '
}

pretty_model_name() {
  echo "$1" |
    sed -E 's/^gemini-/Gemini /; s/-/ /g' |
    awk '{
      for (i = 1; i <= NF; i++) {
        if ($i ~ /^[a-z]/) {
          $i = toupper(substr($i, 1, 1)) substr($i, 2)
        }
      }
      print
    }'
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

echo "Gemini API — peak usage over last ${WINDOW_DAYS} days"
echo

for project_entry in "${PROJECTS[@]}"; do
  project_name="${project_entry%%|*}"
  project_id="${project_entry#*|}"

  prefix="${WORK_DIR}/${project_id}"

  request_usage="${prefix}-requests-usage.json"
  request_limits="${prefix}-requests-limits.json"
  token_usage="${prefix}-tokens-usage.json"
  token_limits="${prefix}-tokens-limits.json"

  rpm_file="${prefix}-rpm.tsv"
  tpm_file="${prefix}-tpm.tsv"
  rpd_file="${prefix}-rpd.tsv"

  rpm_limits_file="${prefix}-rpm-limits.tsv"
  rpd_limits_file="${prefix}-rpd-limits.tsv"
  tpm_limits_file="${prefix}-tpm-limits.tsv"

  rpd_points_file="${prefix}-rpd-points.tsv"
  rpd_days_file="${prefix}-rpd-days.tsv"

  # Fetch the four datasets.
  if ! query_metric "$project_id" "$REQUEST_USAGE_METRIC" "$request_usage" ||
     ! query_metric "$project_id" "$REQUEST_LIMIT_METRIC" "$request_limits" ||
     ! query_metric "$project_id" "$TOKEN_USAGE_METRIC" "$token_usage" ||
     ! query_metric "$project_id" "$TOKEN_LIMIT_METRIC" "$token_limits"; then
    echo
    echo "${project_name} (${project_id})"
    echo "Unable to retrieve usage."
    echo
    continue
  fi

  # -----------------------------------------------------------------------
  # RPM: maximum one-minute request DELTA.
  # -----------------------------------------------------------------------

  jq -r '
    [
      .timeSeries[]?
      | select(.metric.labels.limit_name | contains("PerMinute"))
      | {
          model: .metric.labels.model,
          peak: ([.points[]?.value.int64Value | tonumber] | max // 0)
        }
    ]
    | group_by(.model)[]
    | [
        .[0].model,
        (map(.peak) | max)
      ]
    | @tsv
  ' "$request_usage" > "$rpm_file"

  # -----------------------------------------------------------------------
  # TPM: maximum one-minute input-token DELTA.
  # -----------------------------------------------------------------------

  jq -r '
    [
      .timeSeries[]?
      | select(.metric.labels.limit_name | contains("PerMinute"))
      | {
          model: .metric.labels.model,
          peak: ([.points[]?.value.int64Value | tonumber] | max // 0)
        }
    ]
    | group_by(.model)[]
    | [
        .[0].model,
        (map(.peak) | max)
      ]
    | @tsv
  ' "$token_usage" > "$tpm_file"

  # -----------------------------------------------------------------------
  # RPD:
  #
  # Monitoring exposes the daily-quota series as minute-sized DELTAs.
  # Convert every observation from UTC to the Gemini quota timezone
  # (America/Los_Angeles), total each calendar day, then select the
  # highest day in the 28-day window.
  # -----------------------------------------------------------------------

  jq -r '
    .timeSeries[]?
    | select(.metric.labels.limit_name | contains("PerDay"))
    | .metric.labels.model as $model
    | .points[]?
    | [
        $model,
        .interval.endTime,
        .value.int64Value
      ]
    | @tsv
  ' "$request_usage" > "$rpd_points_file"

  : > "$rpd_days_file"

  while IFS=$'\t' read -r model timestamp value; do
    [[ -z "$timestamp" ]] && continue

    # Normalize an occasional fractional RFC3339 timestamp.
    normalized_timestamp="$(
      printf '%s' "$timestamp" |
        sed -E 's/\.[0-9]+Z$/Z/'
    )"

    # Parse the timestamp explicitly as UTC.
    epoch="$(
      TZ=UTC \
        date -j \
        -f '%Y-%m-%dT%H:%M:%SZ' \
        "$normalized_timestamp" \
        '+%s' \
        2>/dev/null
    )" || continue

    # Gemini RPD quota resets at midnight Pacific time.
    quota_day="$(
      TZ="$QUOTA_TIMEZONE" \
        date -r "$epoch" '+%Y-%m-%d'
    )"

    printf '%s\t%s\t%s\n' \
      "$model" \
      "$quota_day" \
      "$value" \
      >> "$rpd_days_file"

  done < "$rpd_points_file"

  awk -F $'\t' '
    {
      key = $1 SUBSEP $2
      daily[key] += $3
      model[key] = $1
    }

    END {
      for (key in daily) {
        m = model[key]

        if (!(m in peak) || daily[key] > peak[m]) {
          peak[m] = daily[key]
        }
      }

      for (m in peak) {
        printf "%s\t%d\n", m, peak[m]
      }
    }
  ' "$rpd_days_file" |
    sort > "$rpd_file"

  # -----------------------------------------------------------------------
  # Limits
  # -----------------------------------------------------------------------

  jq -r '
    [
      .timeSeries[]?
      | select(.metric.labels.limit_name | contains("PerMinute"))
      | {
          model: .metric.labels.model,
          limit: (
            .points[0].value.int64Value
            // .points[0].value.doubleValue
            // 0
          )
        }
    ]
    | group_by(.model)[]
    | [.[0].model, .[0].limit]
    | @tsv
  ' "$request_limits" > "$rpm_limits_file"

  jq -r '
    [
      .timeSeries[]?
      | select(.metric.labels.limit_name | contains("PerDay"))
      | {
          model: .metric.labels.model,
          limit: (
            .points[0].value.int64Value
            // .points[0].value.doubleValue
            // 0
          )
        }
    ]
    | group_by(.model)[]
    | [.[0].model, .[0].limit]
    | @tsv
  ' "$request_limits" > "$rpd_limits_file"

  jq -r '
    [
      .timeSeries[]?
      | select(.metric.labels.limit_name | contains("PerMinute"))
      | {
          model: .metric.labels.model,
          limit: (
            .points[0].value.int64Value
            // .points[0].value.doubleValue
            // 0
          )
        }
    ]
    | group_by(.model)[]
    | [.[0].model, .[0].limit]
    | @tsv
  ' "$token_limits" > "$tpm_limits_file"

  # -----------------------------------------------------------------------
  # Output
  # -----------------------------------------------------------------------

  models="$(
    cat "$rpm_file" "$tpm_file" "$rpd_file" 2>/dev/null |
      cut -f1 |
      sort -u
  )"

  echo
  echo "# $project_name"
  echo "$project_id"
  echo

  if [[ -z "$models" ]]; then
    echo "No Gemini quota usage found in the last ${WINDOW_DAYS} days."
    echo
    continue
  fi

  printf '%-28s %12s %20s %12s\n' \
    "MODEL" "RPM" "TPM" "RPD"

  printf '%-28s %12s %20s %12s\n' \
    "────────────────────────────" \
    "────────────" \
    "────────────────────" \
    "────────────"

  while IFS= read -r model; do
    [[ -z "$model" ]] && continue

    rpm="$(lookup_value "$rpm_file" "$model")"
    tpm="$(lookup_value "$tpm_file" "$model")"
    rpd="$(lookup_value "$rpd_file" "$model")"

    rpm_limit="$(lookup_value "$rpm_limits_file" "$model")"
    tpm_limit="$(lookup_value "$tpm_limits_file" "$model")"
    rpd_limit="$(lookup_value "$rpd_limits_file" "$model")"

    rpm="${rpm:-0}"
    tpm="${tpm:-0}"
    rpd="${rpd:-0}"

    rpm_limit="${rpm_limit:-?}"
    tpm_limit="${tpm_limit:-?}"
    rpd_limit="${rpd_limit:-?}"

    model_name="$(pretty_model_name "$model")"

    if [[ "$tpm_limit" == "?" ]]; then
      tpm_display="$(human_number "$tpm") / ?"
    else
      tpm_display="$(human_number "$tpm") / $(human_number "$tpm_limit")"
    fi

    printf '%-28s %12s %20s %12s\n' \
      "$model_name" \
      "${rpm} / ${rpm_limit}" \
      "$tpm_display" \
      "${rpd} / ${rpd_limit}"

  done <<< "$models"

  echo
done
