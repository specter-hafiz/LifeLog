# LifeLog

A Daily Journal App built with Flutter.

SETUP INSTRUCTIONS

# Replace your supabase url in constants file

# Replace your anaon key in constants file

# In .env in lifelog-supabase folder (used to setup edge function for journal entry)

     Replace your supabase url
     Replace your SUPABASE_SERVICE_ROLE_KEY in

# Schema design

    journal_entries
        #id - uuid
        #created_at - date
        #user_id - uuid
        #title - text
        #body - text
        #mood - int8

# Limitations

    Didn't handle network connection issues properly
