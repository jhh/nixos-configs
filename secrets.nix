let
  jeff = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel";

  vesta = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGgUVfRwIOyNKefOH6zXIPthvvEu/xObNRG6nSS1ht8";
  luna = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJUJb6IP7qsp/FPbtVKl1CbX2lOYQDjDcgV0c5qAJv9W";
  phobos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEldSjroPbKUueasCQuy88nE9X9Wt1a4lSbd3XSzvps";

  hosts = [ vesta luna phobos ];

in
{
  "common/modules/secrets/upsmon.conf.age".publicKeys = [ jeff luna ];
  "common/modules/secrets/sasl_passwd.age".publicKeys = [ jeff ] ++ hosts;
}
