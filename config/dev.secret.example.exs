import Config

# Configure your database
config :novy_data, NovyData.Repo,
  username: "postgres",
  password: "pass",
  database: "novy_db_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :novy_data,
  aws_access_key_id: "aws_access_key_id",
  aws_secret_access_key: "aws_secret_access_key",
  aws_s3_bucket: "aws_s3_bucket"
