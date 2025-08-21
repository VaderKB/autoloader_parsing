FROM public.ecr.aws/lambda/python:3.12

COPY generate_data.py ${LAMBDA_TASK_ROOT}

CMD ["generate_data.handler"]