# docker-fluent-redis-aws
fluentd container to ship docker logs to a redis queue

##What
This container was created to collect logs from all containers on a host and ship them (JSON Format) to a redis queue. It also adds relevant information about the container to each of the logs. It was created to add two additional fields: AWS_STACK and AWS_INSTANCE_ID. These are read from environment variables that can be passed into the container at startup. If they aren't supplied (as in the example) the fields are simply blank.

Output example:

    {
      "message": "test",
      "docker": {
        "id": "6c5c65b39d888326ea050df0aac41270424d19ea2519760b4697656364048c20",
        "name": "mad_galileo",
        "container_hostname": "6c5c65b39d88",
        "image": "busybox",
        "image_id": "sha256:47bcc53f74dc94b1920f0b34f6036096526296767650f223433fe65c35f149eb",
        "labels": {}
        }
      },
      "stack": "",
      "instance-id": "",
      "host": "$b0e9ca14e5e1",
      "@type": "fluentd",
      "time": "2016-05-11T14:53:46+00:00"
    }

##Why
This was implemented to replace an existing implementation of logspout that was supposed to be achieving similar results, but failing to do so.

##Running
To run this with the configuration specified in this repo simply pull bpsizemore/docker-fluent-redis and run the container on your host. To run with your own customizations, I suggest you clone the repo, modify the dockerfile and config file as you see fit and then do:

```docker build -t fluent-redis-aws .```

This will build the new docker image with your changes.

    docker run -d -v /var/lib/docker/containers:/fluent/containers -v /var/run/docker.sock/var/run/docker.sock fluent-redis-aws
    
**Note: If you do not mount /var/lib/docker/containers: then the container will fail and not be able to obtain logs. If you do not wish to mount /var/run/docker.sock, you can remove the filter block of type docker_metadata and the container will work, however you will not have additional docker output information as shown above.**

##Configuration and Customization
When customizing for your own setup you should refer to the [fluent-plugin-redis-store](https://github.com/pokehanai/fluent-plugin-redis-store) docs for how to customize your redis setup. The default config does an RPUSH to a list item with key "logspout". Simply modify the port number and host to connect to your redis server.

#Debug
In the config file is a match block of type file that is commented out directly above the match block of type redis_store. This block was included for debugging purposes. To test the output of your files without shipping to redis, simply uncomment the file block and comment the redis_store block. Then after you've started your container get into it via a shell and do ```docker run -it $Container_Id /bin/bash``` then once you are inside the container do ```tail -f /var/log/docker/*.log``` This will tail the logs being processed by fluentd and you can view the exact output that will be sent to redis. 

#Adding Gems
To add additional gems just add a gem install line to the Dockerfile. 
To add custom built gems just put the .gem file in the /gems folder.

For additional info on fluentd see: [fluentd documentation](http://docs.fluentd.org/articles/quickstart)
