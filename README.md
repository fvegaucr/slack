# slack
### fer-the-constructor

The following program was build as rudimentary tool to build servers with specific services, making its deployment a little bit easier.

### compatibility
Ubuntu Linux

#### How it works.
 Assuming that the system from where this tool is running is compatibe, then

a- untar the package

b- cd into ./bin run bootstrap.sh with sudo:
sudo ./bootstrap.sh. This will install the dependencies of fer_the_constructor.rb that is the script in charge of the control of the file and call the necessary scripts to install/perform the desire configuration.

c- Once the bootstrap has finished, acceess constructor directory and create or edit the file main.fc which dictates the configuration that want to be applied to the hosts

d- Once the file has being created, run ./fer_the_constructor.rb to apply the configuration


#### main.fc syntax

a- main.fc => This file is the where the tool will read the configuration or of what is require to install the deb. packages This name should not be change; is the main file or class that fer-the-constructor will read to apply the config.

b- File should follow the format describe below
{
"constructor" : [ => this value should not change.
  {
    "package": "name of the package to install or remove",
    "host"   : "hostname, or IP Address wher we want to deploy",
    "action" : "install, remove",
    "notify" : "optional, to inform the service to restart options yes/no"
  },

  {
    "package": "name of the package to install or remove",
    "host"   : "hostname, or IP Address wher we want to deploy",
    "action" : "install, remove",
    "notify" : "optional, to inform the service to restart options yes/no"
  }

  ]
}

c- run the script fer_the_constructor.rb
