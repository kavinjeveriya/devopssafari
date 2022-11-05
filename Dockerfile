FROM python:3.9.2

RUN apt-get update
    
RUN apt-get install  python3-pip -y

WORKDIR app

COPY . .

RUN pip install -r requirements.txt

CMD [ "python", "-m" , "flask", "run", "--host=0.0.0.0"]
