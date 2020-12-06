import os
import uuid
from pathlib import Path

import filetype
from config import DATA_PATH, FRONTEND_IMGS_PATH
from flask import request
from flask_jwt_extended import jwt_required
from flask_restful import Resource, reqparse
from werkzeug.datastructures import FileStorage
from werkzeug.utils import secure_filename


class Upload(Resource):
  @jwt_required
  def post(self):
    try:
      parser = reqparse.RequestParser()

      parser.add_argument('type')
      parser.add_argument('pr_id')
      parser.add_argument('files',
                          type=FileStorage,
                          location='files',
                          required=True,
                          action='append')
      args = parser.parse_args()
      pr_id = args.pr_id
      f_type = args.type if args.type == "slike" or args.type == "doc" else "slike"
      print(args.pr_id, args.type)
      data_dir = f"{DATA_PATH}{pr_id}/{f_type}/"
      fe_dir = f"{FRONTEND_IMGS_PATH}{pr_id}/{f_type}/"
      Path(data_dir).mkdir(parents=True, exist_ok=True)
      Path(fe_dir).mkdir(parents=True, exist_ok=True)
      for f in args.files:
        isPdf = False
        isImage = filetype.is_image(f)
        f.stream.seek(0)
        if (f_type == "doc"):
          isPdf = filetype.guess_extension(f) == "pdf"

        if (not isImage and not isPdf):
          return { "message": f"Fajl '{f.filename}' je pogresnog formata!"}, 400

        new_filename = secure_filename(
            str(uuid.uuid4()) + "." + f.filename.split(".").pop())
        file_path = data_dir + new_filename
        link_path = fe_dir + new_filename
        f.save(file_path)
        if not isPdf:
          os.symlink(file_path, link_path)
        else:
          f.stream.seek(0)
          f.save(link_path)
      return { f_type: get_images(pr_id, f_type) }, 200
    except Exception as e:
      print(e.__class__, e)
      return { 'message': 'failed to save files'}, 500


class Images(Resource):
  def get(self):
    # try:
    pr_id = request.args.get("pr_id")
    images = {
        "slike": get_images(pr_id, "slike"),
        "doc": get_images(pr_id, "doc")
    }
    return images, 200
    # except Exception as e:
    #   print(e.__class__, e)
    #   return { 'message': 'failed to retrive image files'}, 500

  def delete(self):
    try:
      pr_id = request.args.get("pr_id")
      f_type = request.args.get("f_type")
      filename = secure_filename(request.args.get("filename"))
      is_deleted = delete_image(pr_id, f_type, filename)
      if is_deleted:
        images = {
            "slike": get_images(pr_id, "slike"),
            "doc": get_images(pr_id, "doc")
        }
        return images, 200
      else:
        return { "message": "slika nije obrisana"}, 400
    except Exception as e:
      print(e)
      return { "message": "slika nije obrisana"}, 400


def get_images(pr_id, doc_type):
  fe_dir = FRONTEND_IMGS_PATH + pr_id + "/" + doc_type
  Path(fe_dir).mkdir(parents=True, exist_ok=True)
  return [f"{pr_id}/{doc_type}/{filename}" for filename in os.listdir(fe_dir)]


def delete_image(pr_id, f_type, filename):
  if not filename or not f_type or not pr_id:
    print("argument missing")
    return False

  try:
    data_dir = f"{DATA_PATH}{pr_id}/{f_type}/{filename}"
    fe_dir = f"{FRONTEND_IMGS_PATH}{pr_id}/{f_type}/{filename}"
    os.remove(data_dir)
    os.remove(fe_dir)
    return True
  except Exception as e:
    print(e)
    return False
