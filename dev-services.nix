{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    ensureDatabases = [
      "stdauth"
      "polarity"
    ];
    initialScript = pkgs.writeText "postres-init" ''
      CREATE ROLE stdauth WITH LOGIN PASSWORD 'stdauth' CREATEDB;
      CREATE DATABASE stdauth;
      GRANT ALL PRIVILEGES ON DATABASE stdauth TO stdauth;
      ALTER DATABASE stdauth OWNER TO stdauth;

      CREATE ROLE polarity WITH LOGIN PASSWORD 'polarity' CREATEDB;
      CREATE DATABASE polarity;
      GRANT ALL PRIVILEGES ON DATABASE polarity TO polarity;
      ALTER DATABASE polarity OWNER TO polarity;
    '';
  };
}
