# Some Vocab Real Quick:
# ----------------------
# - Dockerfile:
#    + A Dockerfile is a blueprint for making a docker image.
#     It's just a text file named "Dockerfile" (like this one).
#     I believe it's name is case sensitive.
#
# - Image:
#   + A Docker Image is template creating a docker container. 
#    They're created by the 'build' command and converted to a 
#    container by the 'run' command
#
# - Container:
#   + A Docker Container is the actual running code/application.
#    It's got it's own filesystem, the whole nine. *everything
#    that is's been configured to have.


# This Project's Dockerfile:
# --------------------------
# The Dockerfile for this project is very basic.
# This project simply runs a Python file that prints "Hello World!"
# There are many official python Images that already exist so most of the 
# heavy lifting is done with the 'FROM python:3.9' line, but I will explain 
# what the rest does as well.


# We Begin!
# ---------
# Import a base Image
# This line does most of the work for setting up this container.
# It pulls in python. From what I understand it adds a python install to the
# container's filesystem, but I have not verified that. In theory you can look
# through a container's filesystem while it's running but I'm struggling to atm.
FROM python:3.9

# Here are some commands I didn't end up using but I'll explain them anyway:
    # WORKDIR /app  <- Set the working directory inside the container to "/app"
    # COPY . /app   <- Copy the entire local directory (from my laptop) into the container at /app

# ADD adds files from your local environment into your container's filesystem.
# the arguments it takes are 'src' and 'dest'
# These two calls first copy's the src folder from my laptop into the container,
# then copys (copies?) the main.py file into the base folder of the container.
# I think it copys into the working dir, but don't quote me on that. 
ADD src /src
ADD main.py .

# One more command I didn't use:
    # RUN pip install requests beautifulsoup4  <- this would install python dependencies 'requests' and 'beautifulsoup4'.

# This is the command run in the 'terminal' equivalent inside of the container, and is what starts main.py
CMD ["python", "./main.py"]


# Final Words:
# ------------
# This is a very basic Dockerfile, but it's all this project needs.