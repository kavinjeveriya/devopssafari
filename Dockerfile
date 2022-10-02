FROM python:3.9.2

WORKDIR app

COPY . .

RUN pip install -r requirements.txt

CMD [ "python", "-m" , "flask", "run", "--host=0.0.0.0"]