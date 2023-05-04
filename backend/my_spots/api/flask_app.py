import firebase_admin
import json
from firebase_admin import credentials, auth
from dataclasses import asdict
from flask import Flask, request, jsonify

from ..entrypoint import commands, unit_of_work, queries
from ..domain.model import Tag
from .utils import authenticate_token

app = Flask(__name__)
PREFIX = "/api/v1"

cred = credentials.Certificate("my-spots-1-firebase-adminsdk-f0m7r-477a5cec8d.json")
firebase_admin.initialize_app(cred)

# 200 OK
# The request succeeded. The result meaning of "success" depends on the HTTP method:

# 201 Created
# The request succeeded, and a new resource was created as a result.
# This is typically the response sent after POST requests, or some PUT requests.

# 400 Bad Request
# The server cannot or will not process the request due to something
# that is perceived to be a client error (e.g., malformed request syntax,
# invalid request message framing, or deceptive request routing).

# 401 Unauthorized
# Although the HTTP standard specifies "unauthorized", semantically this response means
# "unauthenticated". That is, the client must authenticate itself to get the requested response.

# 404 Not Found
# The server cannot find the requested resource. In the browser, this means the URL is
# not recognized. In an API, this can also mean that the endpoint is valid but the resource
# itself does not exist. Servers may also send this response instead of 403 Forbidden to hide
# the existence of a resource from an unauthorized client. This response code is probably the most
# well known due to its frequent occurrence on the web.

# 500 Internal Server Error
# The server has encountered a situation it does not know how to handle.


@app.route(PREFIX)
def hello():
    """Simple hello world endpoint"""

    return "Welcome to the MySpots api!", 200


@app.route(PREFIX + "/create-user", methods=["POST"])
@authenticate_token
def create_user(uid):
    """Create a new user account"""

    if request.json is None:
        return_obj = {"message": "payload missing in request"}
        return jsonify(return_obj), 400

    try:
        user = commands.create_user(
            id=uid,
            full_name=request.json["full_name"],
            user_name=request.json["user_name"],
            email=request.json["email"],
            phone_number=request.json["phone_number"],
            profile_text=request.json["profile_text"],
            location=tuple(request.json["location"]),
            avatar_url=request.json["avatar_url"],
            uow=unit_of_work.UnitOfWork(),
        )
        return_obj = {"message": "User created successfully!", "user_id": user.id}
        return jsonify(return_obj), 201

    except Exception as exception:
        return_obj = {"message": str(exception)}
        return jsonify(return_obj), 400


@app.route(PREFIX + "/update-user", methods=["POST"])
def update_user():
    """Update an existing user account"""

    if request.json is None:
        return_obj = {"message": "payload missing in request"}
        return jsonify(return_obj), 400

    try:
        commands.update_user(
            user_id=request.json["user_id"],
            full_name=request.json["full_name"],
            user_name=request.json["user_name"],
            email=request.json["email"],
            phone_number=request.json["phone_number"],
            profile_text=request.json["profile_text"],
            location=tuple(request.json["location"]),
            avatar_url=request.json["avatar_url"],
            uow=unit_of_work.UnitOfWork(),
        )
        return_obj = {"message": "User updated successfully!"}
        return jsonify(return_obj), 200

    except Exception as exception:
        return_obj = {"message": str(exception)}
        return jsonify(return_obj), 400


@app.route(PREFIX + "/follow-user", methods=["POST"])
def follow_user():
    """Follows a user"""

    if request.json is None:
        return_obj = {"message": "payload missing in request"}
        return jsonify(return_obj), 400

    try:
        commands.follow_user(
            user_id=request.json["user_id"],
            user_to_follow_id=request.json["user_to_follow_id"],
            uow=unit_of_work.UnitOfWork(),
        )
        return_obj = {"message": "User followed successfully!"}
        return jsonify(return_obj), 200

    except Exception as exception:
        return_obj = {"message": str(exception)}
        return jsonify(return_obj), 400


@app.route(PREFIX + "/create-tag", methods=["POST"])
def create_tag():
    """Create a new tag"""

    if request.json is None:
        return_obj = {"message": "payload missing in request"}
        return jsonify(return_obj), 400

    try:
        tag = commands.create_tag(
            tag_name=request.json["tag_name"],
            uow=unit_of_work.UnitOfWork(),
        )
        return_obj = {"message": "Tag created successfully!", "tag_id": tag.id}
        return jsonify(return_obj), 201

    except Exception as exception:
        return_obj = {"message": str(exception)}
        return jsonify(return_obj), 400


@app.route(PREFIX + "/create-reel", methods=["POST"])
def create_reel():
    """Create a new reel"""

    if request.json is None:
        return_obj = {"message": "payload missing in request"}
        return jsonify(return_obj), 400

    try:
        tags = {Tag(id=t["id"], tag_name=t["tag_name"]) for t in request.json["tags"]}

        reel = commands.create_reel(
            user_id=request.json["user_id"],
            video_url=request.json["video_url"],
            location=tuple(request.json["location"]),
            caption=request.json["caption"],
            description=request.json["description"],
            thumbnail_url=request.json["thumbnail_url"],
            tags=tags,
            uow=unit_of_work.UnitOfWork(),
        )
        return_obj = {"message": "Reel created successfully!", "reel_id": reel.id}
        return jsonify(return_obj), 201

    except Exception as exception:
        return_obj = {"message": str(exception)}
        return jsonify(return_obj), 400


@app.route(PREFIX + "/delete-reel", methods=["POST"])
def delete_reel():
    """Delete a reel"""

    if request.json is None:
        return_obj = {"message": "payload missing in request"}
        return jsonify(return_obj), 400

    try:
        commands.delete_reel(
            reel_id=request.json["reel_id"],
            uow=unit_of_work.UnitOfWork(),
        )
        return_obj = {"message": "Reel deleted successfully!"}
        return jsonify(return_obj), 200

    except Exception as exception:
        return_obj = {"message": str(exception)}
        return jsonify(return_obj), 400


@app.route(PREFIX + "/view-reel", methods=["POST"])
def view_reel():
    """View a reel"""

    if request.json is None:
        return_obj = {"message": "payload missing in request"}
        return jsonify(return_obj), 400

    try:
        commands.view_reel(
            reel_id=request.json["reel_id"],
            user_id=request.json["user_id"],
            uow=unit_of_work.UnitOfWork(),
        )
        return_obj = {"message": "Reel viewed successfully!"}
        return jsonify(return_obj), 200

    except Exception as exception:
        return_obj = {"message": str(exception)}
        return jsonify(return_obj), 400


@app.route(PREFIX + "/like-reel", methods=["POST"])
def like_reel():
    """Like a reel"""

    if request.json is None:
        return_obj = {"message": "payload missing in request"}
        return jsonify(return_obj), 400

    try:
        commands.like_reel(
            reel_id=request.json["reel_id"],
            user_id=request.json["user_id"],
            uow=unit_of_work.UnitOfWork(),
        )
        return_obj = {"message": "Reel liked successfully!"}
        return jsonify(return_obj), 200

    except Exception as exception:
        return_obj = {"message": str(exception)}
        return jsonify(return_obj), 400


@app.route(PREFIX + "/favourite-reel", methods=["POST"])
def favourite_reel():
    """Favourite a reel"""

    if request.json is None:
        return_obj = {"message": "payload missing in request"}
        return jsonify(return_obj), 400

    try:
        commands.favourite_reel(
            reel_id=request.json["reel_id"],
            user_id=request.json["user_id"],
            uow=unit_of_work.UnitOfWork(),
        )
        return_obj = {"message": "Reel favourited successfully!"}
        return jsonify(return_obj), 200

    except Exception as exception:
        return_obj = {"message": str(exception)}
        return jsonify(return_obj), 400


@app.route(PREFIX + "/comment-reel", methods=["POST"])
def comment_reel():
    """Comment on a reel"""

    if request.json is None:
        return_obj = {"message": "payload missing in request"}
        return jsonify(return_obj), 400

    try:
        commands.comment_reel(
            reel_id=request.json["reel_id"],
            user_id=request.json["user_id"],
            comment_text=request.json["comment_text"],
            uow=unit_of_work.UnitOfWork(),
        )
        return_obj = {"message": "Reel commented on successfully!"}
        return jsonify(return_obj), 201

    except Exception as exception:
        return_obj = {"message": str(exception)}
        return jsonify(return_obj), 400


@app.route(PREFIX + "/report-reel", methods=["POST"])
def report_reel():
    """Report a reel"""

    if request.json is None:
        return_obj = {"message": "payload missing in request"}
        return jsonify(return_obj), 400

    try:
        commands.report_reel(
            reel_id=request.json["reel_id"],
            user_id=request.json["user_id"],
            report_text=request.json["report_text"],
            uow=unit_of_work.UnitOfWork(),
        )
        return_obj = {"message": "Reel reported successfully!"}
        return jsonify(return_obj), 200

    except Exception as exception:
        return_obj = {"message": str(exception)}
        return jsonify(return_obj), 400


# Get requests


@app.route(PREFIX + "/decode-access-token", methods=["GET"])
def decode_access_token():
    """Decode an access token"""

    # Fetch the token from the request headers
    auth_header = request.headers.get("Authorization")
    if not auth_header:
        return "Unauthorized", 401

    # Extract the token from the Authorization header
    token = auth_header.split("Bearer ")[1]

    decoded_token = auth.verify_id_token(token)
    uid = decoded_token["uid"]

    return_obj = {"decoded_token": decoded_token, "uid": uid}
    return jsonify(return_obj), 200


@app.route(PREFIX + "/get-user", methods=["GET"])
@authenticate_token
def get_user(uid):
    """Get a user"""

    user = queries.get_user(
        user_id=uid,
        uow=unit_of_work.UnitOfWork(),
    )

    user_dict = asdict(user)
    for attr, value in user_dict.items():
        if isinstance(value, set):
            user_dict[attr] = list(value)

    user_dict["followers"] = len(user_dict["followers"])
    user_dict["following"] = len(user_dict["following"])

    return_obj = {"user": user_dict}
    return jsonify(return_obj), 200


@app.route(PREFIX + "/get-reel", methods=["GET"])
def get_reel():
    """Get a reel"""

    if request.params["reel_id"] is None:
        return_obj = {"message": "No reel_id is supplied in the request parameter"}
        return jsonify(return_obj), 400

    reel = queries.get_reel(
        reel_id=request.params["reel_id"],
        uow=unit_of_work.UnitOfWork(),
    )

    return_obj = {"reel": reel}
    return jsonify(return_obj), 200


@app.route(PREFIX + "/get-nearest-reels", methods=["GET"])
def get_nearest_reels():
    """Get nearest reels"""

    if request.params["user_id"] is None:
        return_obj = {"message": "No user_id is supplied in the request parameter"}
        return jsonify(return_obj), 400

    reels = queries.nearest_reels(
        user_id=request.params["user_id"],
        uow=unit_of_work.UnitOfWork(),
    )

    return_obj = {"reels": reels}
    return jsonify(return_obj), 200


@app.route(PREFIX + "/get-following-reels", methods=["GET"])
def get_following_reels():
    """Get following reels"""

    if request.params["user_id"] is None:
        return_obj = {"message": "No user_id is supplied in the request parameter"}
        return jsonify(return_obj), 400

    reels = queries.following_reels(
        user_id=request.params["user_id"],
        uow=unit_of_work.UnitOfWork(),
    )

    return_obj = {"reels": reels}
    return jsonify(return_obj), 200


@app.route(PREFIX + "/get-search-reels", methods=["GET"])
def get_search_reels():
    """Get search reels"""

    if request.params["keywords"] is None:
        return_obj = {"message": "No keywords is supplied in the request parameter"}
        return jsonify(return_obj), 400

    reels = queries.search_reels(
        keywords=request.params["keywords"],
        uow=unit_of_work.UnitOfWork(),
    )

    return_obj = {"reels": reels}
    return jsonify(return_obj), 200


@app.route(PREFIX + "/get-tag-reels", methods=["GET"])
def get_tag_reels():
    """Get tag reels"""

    if request.params["tag_id"] is None:
        return_obj = {"message": "No tag_id is supplied in the request parameter"}
        return jsonify(return_obj), 400

    reels = queries.tag_reels(
        tag_id=request.params["tag_id"],
        uow=unit_of_work.UnitOfWork(),
    )

    return_obj = {"reels": reels}
    return jsonify(return_obj), 200
