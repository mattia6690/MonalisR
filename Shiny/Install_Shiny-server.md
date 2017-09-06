Install Shiny-server on Centos 7.3
================

Install R
---------

First, you have to install the R base package.

    $ sudo yum install R

Install Shiny
-------------

Once you have installed R, install the package *shiny* using:

    $ sudo su - -c "R -e \"install.packages('shiny', repos ='https://cran.rstudio.com/')\""

Install Shiny-server
--------------------

Download shiny-server using:

    $ sudo wget https://download3.rstudio.org/centos5.9/x86_64/shiny-server-1.5.3.838-rh5-x86_64.rpm

Install typing:

    $ sudo yum install --nogpgcheck shiny-server-1.5.3.838-rh5-x86_64.rpm

Install Git
-----------

Since the app is stored on Gitlab, installing Git is a major advantage.

    sudo yum install git

Gitlab requires a SSH-Key to access the repository via SSH. Use:

    $ ssh-keygen

This will create a directory in your home folder called */ssh/* with two files: the private key */ssh/id\_rsa.* and the public key */ssh/id\_rsa.pub.*. Obtain public key using:

    $ cat ~/.ssh/id_rsa.pub

Copy **public** ssh-key to Gitlab SSH-key settings. Register new **private** SSH-key to local user ssh-agent.

    $ eval $(ssh-agent -s)

    $ ssh-add ~/.ssh/id_rsa

Now you are able to access the Git repository via SSH. On the main project page the SSH link can be found.

### Clone a Git repository

When cloning a git repository, make sure you have writing permission on the corresponding directory. In case you don't have permission you can use:

    $ sudo chmod 777 YOUR_DIRECTORY/

To clone a repository you need the SSH link on the repository's main page. In the directory */srv/shiny-server/* Use:

    $ git clone SSH-LINK

Since the SSH-key is registered to your user account on the server, dont use *sudo* in the command above. The Git repository should now appear in */srv/shiny-server/<REPOSITORY_NAME>*

### Configure Git

Git needs your credentials the frist time you'd like to commit or push something. Enter:

    $ git config --global user.email "your@email"
    $ git config --global user.name "your.name"

Configure Shiny-server
----------------------

The configuration is stored in */etc/shiny-server/shiny-server.conf*. By default, Shiny Server will look for Shiny apps in the folder */srv/shiny-server/*. There is also a directory called *sample-apps*, which can be used to quickly test if you installed everything correctly. The default port used by Shiny is port *3838*.

To reach an app use url:

    http://<YOUR_HOST_NAME>:3838/APP_NAME/

To learn more about installation and configuration of shiny-server take a look at [this guide](http://docs.rstudio.com/shiny-server/).

Special requirements for our Shiny-app
--------------------------------------

First get writing permission on the R library path:

    $ sudo chmod 777 /usr/lib64/R/library/

Install the following libraries:

    $ sudo yum install libcurl libcurl-devel

    $ sudo yum install libxml2-devel

    $ sudo yum install openssl-devel

Now the server should have all the requirements needed.
