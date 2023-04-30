from flask import Flask, request, jsonify

from ..entrypoint import commands, unit_of_work, queries
from ..domain.model import Tag

app = Flask(__name__)
PREFIX = "/api/v1"

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
def create_user():
    """Create a new user account"""

    if request.json is None:
        return_obj = {"message": "payload missing in request"}
        return jsonify(return_obj), 400

    try:
        user = commands.create_user(
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
