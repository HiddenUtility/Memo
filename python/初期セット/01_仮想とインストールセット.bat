set HTTPS_PROXY=http://proxy1000.adm.toyota.co.jp:15520
py -3.11 -m venv .venv
call .venv\Scripts\activate
pip install -r requirements.txt