#!/usr/bin/env python

'''
Module to download releases from Github.

See https://developer.github.com/v3/repos/releases/
'''

import logging
log = logging.getLogger(__name__)
import requests
import json
import sys
import platform


def download(token=None, org='', repo='', release_id=None):
  '''
  Download a release from Github.

  CLI Example:

  .. code-block:: bash

      sudo salt-call --local gh_releases.download <token> <org> <repo> <release_id>
  '''
  # TODO: Consider downloading by release name (e.g. version tag) rather than release_id
  auth = (token, '') if token else None
  release_urls = _get_asset_urls_for_release(token, org, repo, release_id)
  if not release_urls:
    log.info('No releases found')
    return False

  print sys.platform
  print platform.machine()
  options_64_bit = ['AMD64', 'x86_64']
  if sys.platform.startswith('darwin') and platform.machine() in options_64_bit:
    os_arch = 'darwin-amd64'
  elif sys.platform.startswith('linux') and platform.machine() in options_64_bit:
    os_arch = 'linux-amd64'
  else:
    log.info('Unsupported platform')
    return False

  def download_file(url, output_file):
    local_filename = "/tmp/" + output_file
    r = requests.get(url, stream=True, headers={"Accept":'application/octet-stream'}, auth=auth)
    with open(local_filename, 'wb') as f:
      for chunk in r.iter_content(chunk_size=1024):
        if chunk: # filter out keep-alive new chunks
          f.write(chunk)
          f.flush()
    return local_filename

  tar_name = release_urls[os_arch]['name']
  dir_name = release_urls[os_arch]['name'][:-7] # remove .tar.gz # TODO: Use python path methods
  url = release_urls[os_arch]['url']

  if url and tar_name and dir_name:
    local_filename = download_file(url, tar_name)
    return {
      'dirname' : dir_name,
      'filename' : local_filename,
      'url' : url
    }
  else:
    log.info('Could not get url, tar name, and dir name')
    return False

def _get_asset_urls_for_release(token=None, org='', repo='', release_id=None):
  """ Given a release_id finds the URLs for downloadable assets """

  # Assume latest release if release_id=None
  auth = (token, '') if token else None
  page = 0
  page_results = []
  results = []
  while page == 0 or len(page_results):
    page += 1
    r = requests.get('https://api.github.com/repos/{}/{}/releases'.format(org, repo), auth=auth,
                     params={'page': page})
    if not r.ok:
      log.info('Error making github api request: {} {}'.format(r, r.content))
      return False
    page_results = json.loads(r.content)
    results = results + page_results

  if not results:
    return None

  if release_id is None:
    # Get latest release, assuming sorted response from github API
    return _get_asset_urls(results[0])
  else:
    for res in results:
      if res['id'] == release_id:
        return _get_asset_urls(res)
    return None

def _get_asset_urls(release):
  assets = release['assets']
  targets = {
    'darwin-amd64' : None,
    'linux-amd64' : None
  }
  for a in assets:
    # find the asset for each operating system
    # expect names formatted like: "program-v0.1.1-darwin-amd64.tar.gz"
    # TODO: Consider using asset labels to specify osx vs linux
    for t in targets:
      if t in a['name']:
        targets[t] = {}
        targets[t]['url'] = a['url']
        targets[t]['name'] = a['name']

  return targets
