{ ... }:
{
  services.redis.servers."".enable = true;

  services.tempo = {
    enable = true;
    settings = {
      server = {
        http_listen_port = 3200;
      };

      query_frontend = {
        search = {
          duration_slo = "5s";
          # throughput_bytes_slo = 1.073741824e+09;
        };
        trace_by_id = {
          duration_slo = "5s";
        };
      };

      distributor = {
        receivers = {
          jaeger = {
            protocols = {
              thrift_http = { };
              grpc = { };
              thrift_binary = { };
              thrift_compact = { };
            };
          };
          zipkin = { };
          otlp = {
            protocols = {
              http = { };
              grpc = { };
            };
          };
          opencensus = { };
        };
      };

      ingester = {
        max_block_duration = "5m";
      };

      compactor = {
        compaction = {
          block_retention = "1h";
        };
      };

      metrics_generator = {
        registry = {
          external_labels = {
            source = "tempo";
            cluster = "docker-compose";
          };
        };
        storage = {
          path = "/tmp/tempo/generator/wal";
          remote_write = [
            {
              url = "http://localhost:9090/api/v1/write";
              send_exemplars = true;
            }
          ];
        };
      };

      storage = {
        trace = {
          backend = "local";
          wal = {
            path = "/tmp/tempo/wal";
          };
          local = {
            path = "/tmp/tempo/blocks";
          };
        };
      };

      overrides = {
        defaults = {
          metrics_generator = {
            processors = [ "service-graphs" "span-metrics" ];
          };
        };
      };
    };
  };

  services.prometheus = {
    enable = true;
    globalConfig = {
      scrape_interval = "15s";
      evaluation_interval = "15s";
    };
    scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = [
          { targets = [ "localhost:9090" ]; }
        ];
      }
      {
        job_name = "tempo";
        static_configs = [
          { targets = [ "localhost:3200" ]; }
        ];
      }
    ];
  };

  services.grafana = {
    enable = true;
    provision = {
      enable = true;
      datasources.settings = {
        apiVersion = 1;
        datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            uid = "prometheus";
            access = "proxy";
            orgId = 1;
            url = "http://localhost:9090";
            basicAuth = false;
            isDefault = false;
            version = 1;
            editable = false;
            jsonData = {
              httpMethod = "GET";
            };
          }
          {
            name = "Tempo";
            type = "tempo";
            access = "proxy";
            orgId = 1;
            url = "http://localhost:3200";
            basicAuth = false;
            isDefault = true;
            version = 1;
            editable = false;
            apiVersion = 1;
            uid = "tempo";
            jsonData = {
              httpMethod = "GET";
              serviceMap = {
                datasourceUid = "prometheus";
              };
            };
          }
        ];
      };
    };
  };
}