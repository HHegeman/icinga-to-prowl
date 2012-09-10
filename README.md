icinga-to-prowl
===============
THis bash script makes it posible to have icinga send its notifications to prowl.

## Usage

To use this script make an account on www.prowlapp.com and download the prowl app on your ios device.

Put your prowl api key in the contact information of icinga and follow yhe install steps below.

## Install.

copy the prowler.sh file into your icinga/bin/ dir.

Open your icinga commands.cfg file in my case: vim icinga/etc/objects/commands.cfg
and add the following 2 command definitions.

define command {
    command_name    host-notify-by-prowler
    command_line    /usr/bin/printf "%b" "***** Icinga *****\n\nNotification Type: $NOTIFICATIONTYPE$\nHost: $HOSTNAME$\nState: $HOSTSTATE$\nAddress: $HOSTADDRESS$\nInfo: $HOSTOUTPUT$\n\nDate/Time: $LONGDATETIME$\n" | /usr/local/icinga/bin/prowler.sh -p 0 -e "Host: $HOSTNAME$ = $HOSTSTATE$" -n "Icinga" -u "http://www.google.com" -a $CONTACTPAGER$ 
}

define command {
    command_name    service-notify-by-prowler
    command_line    /usr/bin/printf "%b" "***** Icinga *****\n\nNotification Type: $NOTIFICATIONTYPE$\n\nService: $SERVICEDESC$\nHost: $HOSTALIAS$\nAddress: $HOSTADDRESS$\nState: $SERVICESTATE$\n\nDate/Time: $LONGDATETIME$\n\nAdditional Info:\n\n$SERVICEOUTPUT$\n" | /usr/local/icinga/bin/prowler.sh -p 0 -e "Service: $SERVICEDESC$ = $SERVICESTATE$" -n "Icinga" -u "http://www.google.com" -a $CONTACTPAGER$
}

Open your icinga contacts.cfg (in my case: vim icinga/etc/objects/contacts.cfg 
and add the service and host notificationcommands and the pager + your prowl api key.

define contact{
        contact_name                    icingauser
        use                             generic-contact
        alias                           icinga user
        service_notification_commands   service-notify-by-prowler
        host_notification_commands      host-notify-by-prowler
        pager                           <Your Prowl api key>
}

Now just do a service icinga restart and the notifications will be send to your prowl app.

