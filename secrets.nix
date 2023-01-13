let
  jeff = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel";

  # ssh-keyscan <host>
  ceres = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFzrT7SvMHVmqP9olCUcS4WsCy4xnJ41RXdPNK8KDRrG";
  eris = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEv0m+EZsTedPMjzq+a/9rl2c3iAdOKwnFQfGLFHb4y4";
  luna = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJUJb6IP7qsp/FPbtVKl1CbX2lOYQDjDcgV0c5qAJv9W";
  pallas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBJqyGp7HYRXGGZ2zIT9V56AIr+8yrHpmGxBmE7KFQa";
  phobos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEldSjroPbKUueasCQuy88nE9X9Wt1a4lSbd3XSzvps";
  vesta = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGgUVfRwIOyNKefOH6zXIPthvvEu/xObNRG6nSS1ht8";

  hosts = [
    ceres
    eris
    luna
    pallas
    phobos
    vesta
  ];

in
{
  "common/modules/secrets/upsmon.conf.age".publicKeys = [ jeff luna ceres ];
  "common/modules/secrets/rclone.conf.age".publicKeys = [ jeff luna phobos vesta ];
  "common/modules/secrets/sasl_passwd.age".publicKeys = [ jeff ] ++ hosts;
  "common/modules/secrets/aws_secret.age".publicKeys = [ jeff vesta ];
  "common/modules/secrets/puka_secrets.age".publicKeys = [ jeff eris vesta ];
  "common/modules/secrets/strykeforce_website_secrets.age".publicKeys = [ jeff pallas vesta ];
  "common/modules/secrets/route53_secrets.age".publicKeys = [ jeff eris ];
  "common/modules/secrets/pushover_token.age".publicKeys = [ jeff vesta ];
  "common/modules/secrets/smtp_passwd.age".publicKeys = [ jeff eris ];
  "common/modules/secrets/miniflux_secret.age".publicKeys = [ jeff eris ];
  "common/modules/secrets/minio_secret.age".publicKeys = [ jeff luna ];
  "common/modules/secrets/unifi_passwd.age".publicKeys = [ jeff vesta ];
}
