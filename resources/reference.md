# Reference 
This page is just for reference

### Fetch all repository
```
curl -u "USERNAME:PASSWORD" "https://api.bitbucket.org/2.0/repositories/{workspace}"
```
Example:- ``` curl -u "USERNAME:PASSWORD" "https://api.bitbucket.org/2.0/repositories/usthaan/?pagelen=101&next,branch-restrictions" ```

### Fetch branch restriction
```
curl -u "USERNAME:PASSWORD"  "https://api.bitbucket.org/2.0/repositories/{workspace}/{repo_slug}/branch-restrictions/{id}"
```

Example:- ``` curl -u "USERNAME:PASSWORD"  "https://api.bitbucket.org/2.0/repositories/uSthaan-DevOps/testing/branch-restrictions" ```
