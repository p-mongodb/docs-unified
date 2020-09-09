# Ruby Driver / Mongoid Unified Documentation

## Common Operations

### Build & Deploy Upcoming Documentation

This operation requires AWS S3 credentials for the production documentation
bucket.

    export AWS_ACCESS_KEY_ID=xxx AWS_SECRET_ACCESS_KEY=yyy

Then, to build and deploy Ruby + BSON documentation:

    ./script/deploy-docker ruby

For Mongoid documentation:

    ./script/deploy-docker mongoid

### Build Documentation Locally

Assuming your driver is checked out at `~/apps/ruby-driver`, run:

    ./script/build-docker -p ~/apps/ruby-driver ruby

For Mongoid:

    ./script/build-docker -p ~/apps/mongoid mongoid

In either case, the documentation will be available at `build/master/html`.

Note that when building the documentation locally, the generated files
will be owned by root (since they come out of the Docker container).

## License

The contents of `ruby` and `mongoid` subdirectories is licensed under
CC BY-NC-SA 3.0.

The remaining files are licensed under the Apache 2.0 license.
