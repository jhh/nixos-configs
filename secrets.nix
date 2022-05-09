let
  jeff = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel";

  vesta = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGgUVfRwIOyNKefOH6zXIPthvvEu/xObNRG6nSS1ht8";
  luna = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJUJb6IP7qsp/FPbtVKl1CbX2lOYQDjDcgV0c5qAJv9W";
  phobos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEldSjroPbKUueasCQuy88nE9X9Wt1a4lSbd3XSzvps";
  ceres = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIagSXjSePjzj3d3GdUlH8Xe50CQbBNXLiazCCgIH6mI";

  hosts = [ vesta luna phobos ceres ];

in
{
  "common/modules/secrets/upsmon.conf.age".publicKeys = [ jeff luna ceres ];
  "common/modules/secrets/sasl_passwd.age".publicKeys = [ jeff ] ++ hosts;
  "common/modules/secrets/aws_secret.age".publicKeys = [ jeff vesta ];
}
