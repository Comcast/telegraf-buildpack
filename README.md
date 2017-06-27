# Cloud Foundry Telegraf Buildpack

A Cloud Foundry [buildpack](http://docs.cloudfoundry.org/buildpacks/) to run
InfluxData Telegraf as an application in Cloud Foundry.

### Building the Buildpack

1. Make sure you have fetched submodules

    ```sh
    git submodule update --init
    ```

1. Get latest buildpack dependencies

    ```sh
    BUNDLE_GEMFILE=cf.Gemfile bundle
    ```

1. Build the buildpack

    ```sh
    BUNDLE_GEMFILE=cf.Gemfile bundle exec buildpack-packager [ --cached | --uncached ]
    ```

### Use in Cloud Foundry

  Upload the buildpack to your Cloud Foundry and optionally specify it by name

  ```sh
  cf create-buildpack telegraf_buildpack telegraf_buildpack.zip 1
  cf push my_app -b telegraf_buildpack
  ```
