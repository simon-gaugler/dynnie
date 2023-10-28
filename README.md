

# dynnie - Simple DynDNS-Client. Dockerized.

Dynnie aims to be a stable and simple to use DynDNS-Update-Client. Configure the script, start the container - and forget: Your dns entries should always be up to date. In the end dynnie is just a simple bash script, however it offers great flexibility when it comes to configuration.

See the installation and configuration tabs below for how to use dynnie.
Feel free to contribute to the project through pull requests or issues - any help is appreciated!

## Installation & Usage

### Docker run

```bash
docker run 
```



### Docker compose

```yaml

```



## Configuration

| Parameter                   | Description                                                  | required                         | default  | Example                      |
| --------------------------- | ------------------------------------------------------------ | -------------------------------- | -------- | ---------------------------- |
| SERVICE_URL                 | The url of your dynDNS-service ***without*** any protocol (like https://) and without the path parameters. | YES<br />(unless SERVICE is set) | -        | members.dyndns.org/v3/update |
| USERNAME                    | The username required to update your dnyDNS entry. You will either receive this from your provider, can set one yourself or it may be your accounts username. Check your dynDNS providers documentation. | YES                              | -        | example-com-User             |
| PASSWORD                    | The password required to update your dynDNS entry. You will either receive this from your provider, can set one yourself or it may be your accounts password. Check your dynDNS providers documentation. | YES                              | -        | securePass                   |
| HOSTNAME                    | The hostname / entry you want to update. This refers to the actual dns entry that will be updated and point to your new IP (like example.com or sub.example.com) | YES                              | -        | example.com                  |
| INTERVAL_SEC                | You may specify the intervall in which the script will check if a new IP adress has been assigned and then update the dynDNS. Note: The script will ONLY update the dynDNS if a new IPv4 or IPv6 was detected! Set this value in seconds. Default is 60 seconds. | no                               | 60       | 120                          |
| SERVICE                     | ***in progress***<br />Dynnie will come with a variety of dynDNS-services pre-configured to make it as easy as possible for you to get started and keep the configuration overhead minimal. If your service is supported, you may choose to set your service name here, which will configure the SERVICE_URL and URL-Parameters for your service. | no                               | -        |                              |
| DETECT_IP_V4                | Configure whether the script shall detect the external IPv4 adress automatically by caling an external service. If this is disabled, you need to set the IPv4 adress manually using SET_IP_V4 (the ip is then NOT dynamically updated!) | no                               | true     | true / false                 |
| DETECT_IP_V6                | Configure whether the script shall detect the external IPv6 adress automatically by caling an external service. If this is disabled, you need to set the IPv6 adress manually using SET_IP_V6 (the ip is then NOT dynamically updated!) | no                               | false    | true / false                 |
| SET_IP_V4                   | If you want to manually send/update your dns to a specific ip or disable dynamic updates -OR- have other means of providing the IP dynamically into the docker container using this env variable, you may use this method. If this variable is set, the ip will not be fetched but instead this value will always be send to the dyndns.<br />Note: The mechanism of only sending an update to the dyndns when the ip actually changes is still in place! | no                               | -        |                              |
| SET_IP_V6                   | If you want to manually send/update your dns to a specific ip or disable dynamic updates -OR- have other means of providing the IP dynamically into the docker container using this env variable, you may use this method. If this variable is set, the ip will not be fetched but instead this value will always be send to the dyndns.<br />Note: The mechanism of only sending an update to the dyndns when the ip actually changes is still in place! | no                               | -        |                              |
| UPDATE_IP_V6                | Use this to toggle whether the IPv6 adress should be updated at all. Per default, the IPv6 adress will not be updated or included in the update to your dynDNS Provider. Set this to true to include the IPv6 in the update. | no                               | false    | true / false                 |
| URL_VAR_IP_V4 (myip)        | Use this variable to specifiy the name of the URL-Parameter your dynDNS-Provider uses to transfer the IPv4 adress. Many Providers ude "myip", others "ip". Check the URL you received from your provider or read the documentation. | no                               | myip     |                              |
| URL_VAR_IP_V6 (myipv6)      | Use this variable to specifiy the name of the URL-Parameter your dynDNS-Provider uses to transfer the IPv6 adress. Many Providers ude "myipv6", others "ipv6". Check the URL you received from your provider or read the documentation. | no                               | myipv6   |                              |
| URL_VAR_HOSTNAME (hostname) | Use this variable to specifiy the name of the URL-Parameter your dynDNS-Provider uses to transfer the hostname. Many Providers ude "hostname", others "host". Check the URL you received from your provider or read the documentation. | no                               | hostname |                              |
| URL_VAR_APPENDIX            | You may use this additional variable for any additional hardcoded values that you might want or need to include in the update url to your dynDNS Service. It will be applied to the end of the built URL with by a '&' and should follow standard URL-notation. Be sure to escape characters where needed! | no                               | -        | "system=dyndns&myVar=myVal"  |

## Preconfigured Services

The following services are already known to dynnie. This makes it simpler to configure them, since you can just specify the SERVICE-Variable and dynnie will set up the required parameters as stated in the table below.

**NOTE: Please be aware that currently only the ovh service got properly tested. The other providers *should* work as intended, but theres no guarantee yet. Please make sure you test this configuration or specify it yourself. If you notice any errors or problems, please let me know or open an Issue/PullRequest! Thanks :)**

Also, if your Service is not yet available, feel free to add it or let me know - it is really easy to add most services so it would be great to bring a great base of preconfigured services to dynnie.

| Service            | SERVICE | SERVICE_URL                    | URL_VAR_HOSTNAME | URL_VAR_IP_V4 | URL_VAR_IPV6 | URL_VAR_APPENDIX | Notes | Tested           |
| ------------------ | ------- | ------------------------------ | ---------------- | ------------- | ------------ | ---------------- | ----- | ---------------- |
| No-ip.com          | noip    | dynupdate.no-ip.com/nic/update | hostname         | myip          | -            | -                |       | *NO*             |
| dyndns.org         | dyndns  | members.dyndns.org/v3/update   | hostname         | myip          | -            | -                |       | *NO*             |
| duckdns.org        | duckdns | www.duckdns.org/v3/update      | hostname         | myip          | -            | -                |       | *NO*             |
| domains.google.com | google  | domains.google.com/nic/update  | hostname         | myip          | -            | -                |       | *NO*             |
| freedns.afraid.org | freedns | freedns.afraid.org/nic/update  | hostname         | myip          | -            | -                |       | *NO*             |
| ovh.com            | ovh     | www.ovh.com/nic/update         | hostname         | myip          | -            | system=dyndns    |       | **YES**, working |



## Error Handling

Dynnie uses specific exit codes for known errors. When the script exits not cleanly, note the error code. Mostly, the error message before should already give a good indication of what's wrong or missing. In the following list you'll find more detailed information for every error code and how to pissibly fix it:

| Error Code | Reason                                 | Description                                                  | Possible fixes                                               |
| ---------- | -------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 40         |                                        | -reserved-                                                   |                                                              |
| 41         | DYNNIE_ERR_USERNAME_REQUIRED           | You did not specify a username to dynnie via the environment variables or dynnie cannot read/interpret it. | Make sure to specify the username using the correct env-Variable. See the table above. |
| 42         | DYNNIE_ERR_PASSWORD_REQUIRED           |                                                              |                                                              |
| 43         | DYNNIE_ERR_SERVICE_URL_REQUIRED        |                                                              |                                                              |
| 44         | DYNNIE_ERR_HOSTNAME_REQUIRED           |                                                              |                                                              |
| 45         | DYNNIE_ERR_INTERVAL_SEC_REQUIRED       |                                                              |                                                              |
| 46         | DYNNIE_ERR_DETECT_IP_CONFIG_REQUIRED   |                                                              |                                                              |
| 47         | DYNNIE_ERR_DETECT_IPV6_CONFIG_REQUIRED |                                                              |                                                              |
| 48         |                                        | -reserved-                                                   |                                                              |
| 49         | DYNNIE_ERR_SERVICE_UNKNOWN             |                                                              |                                                              |
