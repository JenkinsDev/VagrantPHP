# VagrantPHP

Simple to use Vagrant virtual host setup for you to handle of your PHP 5.5 development. All that you have to do to get started is run the started command:

* `git clone https://www.github.com/JenkinsDev/VagrantPHP`
* `cd VagrantPHP`
* `vagrant up`

Now all that is left is to put your projects in the `sites` directory and code to your hearts content! When you are done you can run `vagrant halt` to freeze the Vagrant VM.

## Databases


### MySQL

IP: localhost/127.0.0.1

Port: 33060 (This is forwarded to our VM's 3306 port)

Username: root

Password: password


### MongoDB

IP: localhost/127.0.0.1

Port: 20017 (This is forwarded to our VM's 27017 port)

Username: root

Password: password


### Redis

IP: localhost/127.0.0.1

Port: 63790 (This is forwarded to our VM's 6379 port)