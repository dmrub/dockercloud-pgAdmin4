#!/bin/sh
	
cd `python -c 'import sys,site,os.path; p=sys.argv[1]; print next(iter([os.path.join(i, p) for i in site.getsitepackages() if os.path.exists(os.path.join(i, p))] or []), "")' pgadmin4`
exec python pgAdmin4.py
