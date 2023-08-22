@echo off

call .venv\Scripts\activate

pip freeze > requirements.txt

pip download wheel -d libs
pip download -r requirements.txt -d libs

cmd /k