let
  jeff = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel";

  # ssh-keyscan <host>
  ceres = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFzrT7SvMHVmqP9olCUcS4WsCy4xnJ41RXdPNK8KDRrG";
  eris = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEv0m+EZsTedPMjzq+a/9rl2c3iAdOKwnFQfGLFHb4y4";
  luna = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJUJb6IP7qsp/FPbtVKl1CbX2lOYQDjDcgV0c5qAJv9W";
  pallas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTUy7vfg/hbidaq9TGvUDE9PDMa+pa/BvUNUK9ZrSCw";
  phobos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEldSjroPbKUueasCQuy88nE9X9Wt1a4lSbd3XSzvps";
  vesta = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGgUVfRwIOyNKefOH6zXIPthvvEu/xObNRG6nSS1ht8";
  titan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMU/kxkkMvbR2VHaAhHwY6XNwKOEHcwC+YtOAcEqh1e";

  hosts = [
    ceres
    eris
    luna
    pallas
    phobos
    vesta
    titan
  ];

in
{
  "upsmon.conf.age".publicKeys = [ jeff luna ceres ];
  "rclone.conf.age".publicKeys = [ jeff luna phobos vesta ];
  "sasl_passwd.age".publicKeys = [ jeff ] ++ hosts;
  "aws_secret.age".publicKeys = [ jeff pallas ];
  "puka_secrets.age".publicKeys = [ jeff eris vesta ];
  "strykeforce_website_secrets.age".publicKeys = [ jeff pallas phobos vesta ];
  "route53_secrets.age".publicKeys = [ jeff eris ];
  "pushover_token.age".publicKeys = [ jeff vesta ];
  "pgadmin_passwd.age".publicKeys = [ jeff pallas ];
  "smtp_passwd.age".publicKeys = [ jeff eris ];
  "miniflux_secret.age".publicKeys = [ jeff eris ];
  "minio_secret.age".publicKeys = [ jeff luna ];
  "unifi_passwd.age".publicKeys = [ jeff vesta ];
}
