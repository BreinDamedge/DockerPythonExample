# Docker Example: Python3 "Hello World!" | Jacob Ableidinger | 12/28/2023

## Overview:
The goal of this project was to test the feasibility of running python projects in Docker containers to simplify running them outside of my local machine (I intend to move longer running jobs to my desktop this way) in the future.

## Steps:
1. Install Docker
1. Build the project image
1. Run the project as a container
1. Do a little dance
1. Do it again with a Registry (optional: This was what caused me suffering, but it was also the reason I did this in the first place)
    1. Create a local Registry (as a container ofc)
    1. Push your image to the registry
    1. Delete your local copy
    1. Pull the image back from the registry
    1. Run the image as a container again

## Lettuce Begin:
### Install Docker:
- This will be easiest with docker desktop on windows. If you're running linux you probably don't need my help to install stuff.
- Here is the link to download [Docker Desktop](https://www.docker.com/products/docker-desktop/), which is an application that contains docker engine (which is open source and all that jazz) and some other stuff on top to make docker a bit friendlier to those who aren't super familiar with a terminal. We will be using the terminal for most of this guide.
    > **NOTE:** You will need to make an account for docker desktop, but you can do it with your google account so it's fairly painless.
- Once you've installed Docker, open a terminal window and run: `docker run hello-world` (may need `sudo` on linux \o/) to verify that Docker is installed and working.

### Build Python-Test:
1. In a terminal window navigate to this folder wherever you've put it (open folder in vscode is a quick way to do this)
1. Run `docker build -t python-test .` 
    - `-t` sets the 'tag' of the image to "python-test"
    - `.` is the directory in which Docker should look for `Dockerfile`

### Run Python-Test:
1. In your terminal (from wherever now) run `docker run --name python-test-container python-test`
    - `--name` sets the name of the container created
- You should now see "Hello World!" in your terminal.
- Wanna see it again?
    1. run `docker ps -a` to list all containers on your machine
        - you should see `python-test` on there
    1. run `docker start -a python-test`
        - `-a` runs the container "attatched" so it connects stdin/out to your terminal.
    - Did it do it again!?
    
### Dance Time!

## Registry Time:
- If you'd like to go one step further to see the fairly simple process that has caused me so much pain the last few days I will walk you through that as well but just the painless low effort part.

### Create A Registry
- If you'd like a slightly more detailed explaination you can open the .html file in the `RegistryWalkthrough` folder for the guide I followed but here are the commands:
1. Run `docker run -d -p 5000:5000 --restart unless-stopped --name registry registry:2` in terminal
    - `-d` runs the container in detatched mode (no terminal)
    - `--restart` specifies how/if the container should be restarted by the daemon on exit.
        - The guide uses `always` but `unless-stopped` lets you manually stop it without deleting the whole container.
    - `-p` specifies publish container port to host port
    - `--name` sets the container name to registry
1. Run `docker ps` to confirm the container is running

1. Configure docker to use http for the registry (otherwise it will get upset that it's insecure)
    1. Add `{ "insecure-registries": ["your_hostname.local:5000"] }` to your `daemon.json` file. 
    - **Linux:** Open the `/etc/docker/daemon.json` file, if this file doesn't exist, just make it.
    - **Windows:** I found it easiest to open docker desktop and go to `Settings > Docker Engine` and add it there if you don't want to dig through your drive.
        - **DID YOU KNOW:** Your hostname can be found in your system settings and if you're trying to use it instead of your ip address, you should add .local and it should do the trick (assuming you're on the same local network), because I sure didn't!
        - **A SECOND NOTE:** it seems that my network is not case sensitive as I can ping my laptop @ `smallpapa.local` and `SmallPapa.local` no problem, but docker's `daemon.json` does appear to be case sensitive. Be aware, as this could potentially cause an issue.

### Push Python-Test
1. To push to your registry first tag your image with the ip and port it is destined for:
    - `docker tag python-test your_hostname.local:5000/python-test`
1. Then push the image:
    - `docker push your_hostname.local:5000/python-test`

### Delete Python-Test
1. Run `docker images` to list all the images on your machine.
1. Use `docker rmi your_hostname.local:5000/python-test` to remove the corresponding image.
1. To be extra sure you can also run `docker rmi python-test -f` to remove the non-registry version
    - `-f` forces deletion
1. Running `docker images` again should reveal that the images are all nice and gone.

### Pull Python-Test
1. Now to undo all your nice work run `docker pull your_hostname.local:5000/python-test` to bring back what you've lost.
1. Because I dislike typing I'll make us do more now, running `docker tag your_hostname.local:5000/python-test python-test` now you don't have to type the full registry address.

### Run Python-Test
1. Run `docker run --name python-test2 python-test`
    - That should do it.

## Cleanup:
- `docker ps -a` should list all your containers
- `docker rm [container-name]` should delete a target container
- `docker images` should list your images
- `docker rmi [image-name/id]` should delete an image
- `docker container prune` will delete all stopped containers
- `docker image prune` will delete all images that are untagged and unreferenced by containers. running `docker image prune -a` will remove all containers that aren't referenced by a container.