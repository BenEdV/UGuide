#!/bin/bash


############################## Setup ##############################

# Generates environment files with variables used to connect the LearnLytics services
# run before building production containers
function generateProductionEnv()
{
	mkdir ~/envfiles

	# Postgres Metadb
	echo "MetaDatabase create postgres user to access database"
	read -rp "Username: " uservar
	echo "DATABASE_USERNAME=$uservar" > ~/envfiles/backend_production.env
	echo "POSTGRES_USER=$uservar" > ~/envfiles/postgresdb_production.env
	read -rsp "Password: " passvar
	echo ""
	echo "DATABASE_PASSWORD=$passvar" >> ~/envfiles/backend_production.env
	echo "POSTGRES_PASSWORD=$passvar" >> ~/envfiles/postgresdb_production.env
	{
		echo "DATABASE_DIALECT=postgres"
		echo "DATABASE_HOST=postgresdb"
		echo "DATABASE_PORT=5432"
		echo "DATABASE_DATABASE=backend_db"
	} >> ~/envfiles/backend_production.env
	echo "POSTGRES_DB=backend_db" >> ~/envfiles/postgresdb_production.env
	echo "Password for root user of postgres database"
	read -rsp "Password: " rootpassvar
	echo ""
	echo "POSTGRES_ROOT_PASSWORD=$rootpassvar" >> ~/envfiles/postgresdb_production.env

	# Mongo LRS db
	echo "LRS Database create mongo user for LRS"
	read -rp "Username: " uservar
	read -rsp "Password: " passvar
	echo ""
	read -rp "Database name: " dbvar
	read -rp "App key: " keyvar
	echo "APP_KEY=$keyvar" > ~/envfiles/learninglocker_production.env
	echo "MONGODB_URL=mongo://$uservar:$passvar@mongodb/$dbvar" >> ~/envfiles/learninglocker_production.env

	# LRS config
	echo "LRS Account, this account will need to be created in the LRS setup. Please refer to the README for further instruction."
	read -rp "Username: " uservar
	echo "LRS_USERNAME=$uservar" >> ~/envfiles/backend_production.env
	read -rsp "Password: " passvar
	echo "LRS_PASSWORD=$passvar" >> ~/envfiles/backend_production.env

	# SAML config
	read -p "Do you want to use SAML authentication in your environment " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		read -rp "Provider name: " providervar
		echo "SAML_PROVIDER=$providervar" >> ~/envfiles/backend_production.env
		read -rsp "Host: " hostvar
		echo "SAML_HOST=$hostvar" >> ~/envfiles/backend_production.env
		read -rp "Client ID: " clientidvar
		echo "SAML_CLIENT_ID=$clientidvar" >> ~/envfiles/backend_production.env
		read -rsp "Client Secret: " clientsecretvar
		echo "SAML_CLIENT_SECRET=$clientsecretvar" >> ~/envfiles/backend_production.env
		read -rp "Redirect URI: " redirectvar
		echo "SAML_REDIRECT_URI=$redirectvar" >> ~/envfiles/backend_production.env
	fi
}
