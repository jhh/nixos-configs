let
  jeff = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqpWpNJzfzioGYyR9q4wLwPkBrnmc/Gdl6JsO+SUpel";

  # ssh-keyscan <host>
  ceres = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPfiXFXZVG3HHUcqujuEcsiJM2Eov+yriP5VVynEx+v0";
  eris = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPsAbbFQgKY1zznXgTMOxOj+jmhCIRrJx1TO61Z4djZ";
  luna = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJUJb6IP7qsp/FPbtVKl1CbX2lOYQDjDcgV0c5qAJv9W";
  pallas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBeB+n+G1c6c2VZvPlfllS/Hnw7u6S8mn7ILWMK29iwe";
  phobos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEldSjroPbKUueasCQuy88nE9X9Wt1a4lSbd3XSzvps";
  styx = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPKrJZkAwYmRKQf3DTxZi8ANhCLMJpW364ThA5HGIhtC";
  titan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMU/kxkkMvbR2VHaAhHwY6XNwKOEHcwC+YtOAcEqh1e";
  vesta = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1WkKloYOC0Uk7wROCbhvZzRIQdkrVnNsH1XBhTIENY";

  hosts = [
    ceres
    eris
    luna
    pallas
    phobos
    styx
    titan
    vesta
  ];

in
{
  "aws_secret.age".publicKeys = [ jeff pallas ];
  "miniflux_secret.age".publicKeys = [ jeff eris ];
  "minio_secret.age".publicKeys = [ jeff luna ];
  "paperless_admin_passwd.age".publicKeys = [ jeff eris ];
  "paperless_passwd.age".publicKeys = [ jeff ] ++ hosts;
  "pgadmin_passwd.age".publicKeys = [ jeff pallas styx ];
  "puka_secrets.age".publicKeys = [ jeff eris vesta ];
  "pushover_token.age".publicKeys = [ jeff vesta ];
  "rclone.conf.age".publicKeys = [ jeff ] ++ hosts;
  "route53_secrets.age".publicKeys = [ jeff eris ];
  "sasl_passwd.age".publicKeys = [ jeff ] ++ hosts;
  "smtp_passwd.age".publicKeys = [ jeff eris ];
  "strykeforce_website_secrets.age".publicKeys = [ jeff pallas phobos vesta ];
  "todo_secrets.age".publicKeys = [ jeff eris styx ];
  "unifi_passwd.age".publicKeys = [ jeff vesta ];
  "upkeep_secrets.age".publicKeys = [ jeff eris styx ];
  "upsmon.conf.age".publicKeys = [ jeff luna ];
}
