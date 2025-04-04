from dataclasses import asdict
from functools import wraps
from firebase_admin import auth
from flask import request
from uuid import uuid5, NAMESPACE_OID

import json


def firebaseUidToUUID(uid: str) -> str:
    return str(uuid5(NAMESPACE_OID, uid))


def authenticate_token(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        # Fetch the token from the request headers
        auth_header = request.headers.get("Authorization")
        if not auth_header:
            return "Unauthorized", 401

        # Extract the token from the Authorization header
        token = auth_header.split("Bearer ")[1]

        try:
            # Verify and decode the token
            decoded_token = auth.verify_id_token(token)

            # Extract the user ID and other information from the decoded token
            uid = firebaseUidToUUID(decoded_token["uid"])

            # Call the decorated function with the extracted information
            return f(uid, *args, **kwargs)

        except auth.InvalidIdTokenError:
            # Token is invalid or expired
            return "Unauthorized", 401

    return decorated_function


def jsonify_reel(reel):
    reel_dict = asdict(reel)
    for attr, value in reel_dict.items():
        if isinstance(value, set):
            reel_dict[attr] = list(value)

    attributes = ["favourites", "likes", "views", "comments"]
    for attr in attributes:
        reel_dict[attr] = (
            reel_dict[attr]
            if isinstance(reel_dict[attr], int)
            else len(reel_dict[attr])
        )

    return reel_dict
