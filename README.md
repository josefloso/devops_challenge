# Challenge
Software Developers have been tasked with creating an interface for collecting user feedback and mailing it. They have chosen to separate the user interface from the mailing process using separate webserver and worker service as described in the ***Asynchronous Tasks with Django and Celery*** section.

As a Devops engineer, you are asked to accomplish the following tasks to make the application production ready:

### 1. Production Readiness
Identify and separate points of concern by
* Implementing a production webserver.
* Implementing a reverse proxy to serve traffic.
* Implementing a production database.
* Managed services to handle automatic start/restarts of processes.

### 2. Containerization
In order for developers to submit an exact replica of their application to QA for testing, create a containerized stack with easily deployable artifacts via a configuration file(yaml/json/etc).

### 3. Deploy to Cloud
Using minikube as your cloud infrastructure, setup a k8s cluster and deploy the now containerized stack, with enhancements including:
* Load balancer
* High availability/redundancy
* Application logging and monitoring
* CI/CD pipeline
* Documentation
* etc

# Asynchronous Tasks with Django and Celery

Example project for integrating Celery and Redis into a Django application.
This repository holds the code for the Real Python [Asynchronous Tasks With Django and Celery](https://realpython.com/asynchronous-tasks-with-django-and-celery/) tutorial.

## Setup (Linux)

To try the project, set up a virtual box environment.
Install [VirtualBox](https://www.virtualbox.org/manual/ch02.html) and [Vagrant](https://www.vagrantup.com/docs/installation)

**Note:** *Remember to activate Virtualization for VirtualBox to work - https://www.nakivo.com/blog/use-virtualbox-quick-overview/*


The provided Vagrantfile will:
1. Download ubuntu 18.04 and install in a virtual box.
2. Install required dependencies.
3. Forward required ports to serve the application outside of the box.
4. Install and start Redis as a task queue.
5. Copy the project code into the box and install project requirements.

```
$ vagrant up --provider virtualbox
```

## Running the application
The application consists **2** parts, a rudimentary [Django](https://www.djangoproject.com/) webserver and [Celery](https://docs.celeryq.dev/en/stable/django/first-steps-with-django.html) worker.

Once the box has be provisioned, you need to start the 2 processes to be run together side-by-side:
1. Django
2. Celery

Open two different terminal windows and ssh into the vagrant box with `vagrant ssh`:
##### Django app
```sh
$ cd /opt/devops_challenge_app
$ source venv/bin/activate
$ (venv) python3 manage.py runserver 0.0.0.0:8000
```

##### Celery worker
```sh
$ cd /opt/devops_challenge_app
$ source venv/bin/activate
$ (venv) python -m celery -A django_celery worker
```

When all three processes are running, you can go to `localhost:8080/` and submit a feedback response. Celery will simulate a work-intensive process and send an email at the end of it. You'll see the email message show up in the log stream on the terminal window where the Celery worker is running.



![Screenshot 2022-11-28 at 20 52 26](https://user-images.githubusercontent.com/7838284/204348064-86b50495-9dc7-42af-8067-602e3e1d64e3.png)
![Screenshot 2022-11-28 at 20 51 56](https://user-images.githubusercontent.com/7838284/204348081-32c651d6-b184-4cd1-a4a1-3016abcc16cd.png)


##### Production Readiness

Gunicorn has been a production webserver.
Nginx has been used a reverse proxy to serve traffic.

Instead of having to run each process (e.g., Django, Celery worker, Celery beat, Flower, Redis, Postgres, etc.) manually, each from a different terminal window, after we containerize each service, Docker Compose enables us to manage and run the containers using a single command.

Start by adding a docker-compose.yml file to the project root.

Here, we defined six services:
1. web is the Django dev server
2. db is the Postgres server
3. redis is the Redis service, which will be used as the Celery message broker and result backend
4. celery_worker is the Celery worker process
5. flower is the Celery dashboard
6. Nginx used as a reverse proxy 

Create a new folder to store environment variables in the project root called .env.dev


Create a Dockerfile which is a text file that contains the commands required to build an image.

#### Entrypoint
We used a depends_on key for the web service to ensure that it does not start until both the redis and the db services are up. Just because the db container is up does not mean the database is up and ready to handle connections. So, we can use a shell script called entrypoint to ensure that we can actually connect to the database before we spin up the web service.

Start by building the images:
```
$ docker-compose build

```
Once the images are built, spin up the containers in detached mode:
```
$ docker-compose up -d

```

This will spin up each of the containers based on the order defined in the depends_on option:
redis and db containers first
Then the web, celery_worker, celery_beat, and flower containers
Once the containers are up, the entrypoint scripts will execute and then, once Postgres is up, the respective start scripts will execute. The Django migrations will be applied and the development server will run. The Django app should then be available.

Make sure you can view the Django welcome screen at http://localhost/. You should be able to view the Flower dashboard at http://localhost:5555/ as well.




