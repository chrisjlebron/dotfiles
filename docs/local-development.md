# Local Development

- mkcert for local TLS certs
  - <https://medium.com/@TomVance/local-domains-with-https-469036775818>
  - <https://github.com/FiloSottile/mkcert>
- dnsmasq for DNS forwarding & host resolution
  - `brew install dnsmasq`
  - `ls $(brew --prefix)/etc`
    - There should be a `dnsmasq.d/` dir and a `dnsmasq.conf` file
  - Open `dnsmasq.conf` and uncomment this line:
    - `conf-dir=/opt/homebrew/etc/dnsmasq.d/,*.conf`
  - You can now make as many conf files as you like and put them in `$(brew --prefix)/etc/dnsmasq.d/` and they'll be honored
  - We'll make a default dev conf file:

    ```shell
    cd $(brew --prefix)/etc/dnsmasq.d
    touch default-development.conf
    vi default-development.conf

    # default-development.conf
    address=/.test/127.0.0.1

    # save and exit

    # restart dnsmasq
    sudo brew services restart dnsmasq

    # test the configuration
    dig foobar.test @127.0.0.1
    # ==> foobar.test.        0 IN A    127.0.0.1
    ```

  - Now we tell macOS to route all requests to `*.test` URLs via dnsmasq:

    ```shell
    # ensure resolver directory
    sudo mkdir /etc/resolver

    # create resolver file for `.test` domain
    # and point nameserver to localhost IP
    echo "nameserver 127.0.0.1" | sudo tee /etc/resolver/test > /dev/null
    ```

  - Test that we're now using the desired DNS resolvers:

    ```shell
    # Make sure you can still access the outside world (IP may vary)
    ping -c 1 google.com
    # ==> PING google.com (142.250.189.174): 56 data bytes...

    # Make sure all requests to `*.test` resolve to localhost (127.0.0.1)
    ping -c 1 anything.test
    # ==> PING anything.test (127.0.0.1): 56 data bytes
    ```

  - See <https://gist.github.com/ogrrd/5831371> for setup
  - See <https://www.stevenrombauts.be/2018/01/use-dnsmasq-instead-of-etc-hosts/> for more examples
- Don't use `*.dev` for local domains
  - <https://www.reddit.com/r/webdev/comments/gyehla/regular_reminder_dont_try_to_use_dev_domains_for/>
  - Use `*.test` instead, or `dev.*` if you have a domain