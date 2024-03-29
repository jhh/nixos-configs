let
  jeff = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel";

  # ssh-keyscan <host>
  ceres = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPfiXFXZVG3HHUcqujuEcsiJM2Eov+yriP5VVynEx+v0";
  eris = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPsAbbFQgKY1zznXgTMOxOj+jmhCIRrJx1TO61Z4djZ";
  luna = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJUJb6IP7qsp/FPbtVKl1CbX2lOYQDjDcgV0c5qAJv9W";
  pallas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBeB+n+G1c6c2VZvPlfllS/Hnw7u6S8mn7ILWMK29iwe";
  phobos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEldSjroPbKUueasCQuy88nE9X9Wt1a4lSbd3XSzvps";
  vesta = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1WkKloYOC0Uk7wROCbhvZzRIQdkrVnNsH1XBhTIENY";
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
  "upsmon.conf.age".publicKeys = [ jeff luna ];
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
