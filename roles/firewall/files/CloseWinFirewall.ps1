# Turning Off Firewall

#Set-NetFirewallProfile profilename| -all -DefaultInboundAction Allow|Block -DefaultOutboundAction Allow|Block
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
#Set-NetFirewallProfile -All -DefaultInboundAction Allow -DefaultOutboundAction Allow
#OR
#netsh advfirewall set allprofiles state off


