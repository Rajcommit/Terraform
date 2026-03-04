# Assignment 3: Dockerize Node.js App - Complete Learning Guide
## Full Docker Lifecycle: Build → Run → Push → Pull → Run

**Date:** March 2, 2026
**Duration:** ~4 hours
**Status:** ✅ COMPLETED
**Docker Hub:** rajabhishekcommit/node-assignment:1.0

---

## 📂 WHAT WE BUILT

```
assignment-3/
├── Dockerfile          # Our Dockerfile (written from scratch!)
├── package.json        # Node.js dependencies
├── app.js              # Express application
├── bin/www             # Startup script (listens on port 3000)
├── routes/             # Express routes
├── views/              # Handlebars templates
├── public/             # Static files (images, CSS)
├── answer/Dockerfile   # Bret Fisher's answer (for reference)
└── LEARNING.md         # This file!
```

**Result:** Node.js Express app containerized and pushed to Docker Hub!

---

## 🐳 DOCKERFILE EXPLAINED

```dockerfile
FROM node:6-alpine
RUN apk add --no-cache tini
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install && npm cache clean --force
COPY . /usr/src/app/
EXPOSE 3000
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "./bin/www"]
```

### Line-by-Line:

---

### `FROM node:6-alpine`
- **node** = Official Node.js image (lowercase! not "Nodejs")
- **6** = Version 6 (old but required by assignment)
- **alpine** = Tiny Linux (50MB vs 660MB regular!)
- Format: `image:version-os`
- NEVER use `latest` tag - pin specific versions!

---

### `RUN apk add --no-cache tini`
- **RUN** = Execute command during build
- **apk** = Alpine's package manager (not apt-get!)
- **--no-cache** = Don't save package lists (saves space)
- **tini** = Tiny init system for containers

**What is tini?**
- Process manager for containers
- Handles zombie processes (orphaned child processes)
- Ensures graceful shutdown when container stops
- Forwards signals (like Ctrl+C) to the app properly

---

### `WORKDIR /usr/src/app`
- Creates `/usr/src/app` directory AND moves into it
- All subsequent commands run in this directory
- Better than `RUN mkdir -p /usr/src/app && cd /usr/src/app`
- WORKDIR does TWO things: creates + changes directory

**Why after RUN?**
- tini installs to `/sbin/tini` (system-level)
- Doesn't need to be in our app directory
- Install system tools first, then set up app directory

---

### `COPY package*.json ./`
- Copies package.json AND package-lock.json (if exists)
- `*` = Wildcard (matches both files)
- `./` = Current WORKDIR (/usr/src/app)

**Why copy this FIRST?**
- Docker caches layers!
- If package.json doesn't change → npm install is CACHED
- Only re-installs when dependencies change
- Saves MINUTES on rebuilds!

---

### `RUN npm install && npm cache clean --force`
- **npm install** = Download and install all packages from package.json
- **&&** = Chain commands in ONE layer (smaller image)
- **npm cache clean --force** = Delete npm's download cache
- Combined in one RUN = one layer instead of two

**Why `&&` not two RUN commands?**
- Each RUN creates a new layer
- More layers = bigger image
- Combining = fewer layers = smaller image

---

### `COPY . /usr/src/app/`
- Copies ALL remaining files from project folder to container
- Done AFTER npm install for layer caching
- Includes: app.js, routes/, views/, public/, bin/

**Why copy AFTER npm install?**
- If you change app.js, Docker only rebuilds from this step
- npm install layer stays cached!
- Much faster rebuilds!

---

### `EXPOSE 3000`
- Documents that the app uses port 3000
- Does NOT actually open the port
- Just a sticky note for documentation
- Actual port mapping: `docker run -p 80:3000`

**Port Mapping Explained:**
```
-p 80:3000
   ↑   ↑
   │   └── Container port (app listens here, FIXED)
   └── Host port (YOUR choice, can be anything)
```

---

### `ENTRYPOINT ["/sbin/tini", "--"]`
- Sets tini as the ALWAYS-running process
- Cannot be easily overridden
- `--` separates tini args from the actual command

### `CMD ["node", "./bin/www"]`
- Default command passed to ENTRYPOINT
- Can be overridden when running container
- JSON array format (recommended over shell form)

**ENTRYPOINT + CMD combined:**
```
/sbin/tini -- node ./bin/www
(ENTRYPOINT)   (CMD)
(LOCKED)       (Can change)
```

---

## 🎓 KEY CONCEPTS LEARNED

### 1. ENTRYPOINT vs CMD

**CMD alone:**
- Full command that runs when container starts
- Easy to override completely
- Example: `CMD ["/sbin/tini", "--", "node", "./bin/www"]`

**ENTRYPOINT + CMD:**
- ENTRYPOINT = Always runs (the TV)
- CMD = Default arguments (the channel)
- Docker combines them: ENTRYPOINT + CMD
- CMD can be overridden, ENTRYPOINT stays

**Analogy:**
- ENTRYPOINT = Chrome browser (always opens)
- CMD = google.com (default website, can change)

---

### 2. Layer Caching Strategy

```dockerfile
COPY package*.json ./        # Step 1: Copy dependency file
RUN npm install              # Step 2: Install (CACHED if package.json unchanged)
COPY . .                     # Step 3: Copy app code (rebuilds if code changes)
```

**Why this order matters:**
- Change app.js → Only Step 3 rebuilds
- Change package.json → Steps 2 AND 3 rebuild
- Change nothing → Everything cached!

---

### 3. Docker Build Process

Each step creates a LAYER:
```
Step 1: FROM node:6-alpine        → Base layer (downloaded)
Step 2: RUN apk add tini          → Creates temp container, runs command, saves layer
Step 3: WORKDIR /usr/src/app       → Creates directory layer
Step 4: COPY package*.json ./      → File copy layer
Step 5: RUN npm install            → Install layer (biggest!)
Step 6: COPY . /usr/src/app/       → App code layer
Step 7: EXPOSE 3000                → Metadata only
Step 8: ENTRYPOINT [...]           → Metadata only
Step 9: CMD [...]                  → Metadata only
```

**"Using cache"** = Docker reused a previous layer (fast!)
**"Running in abc123"** = Docker created temp container (slow, doing work)

---

### 4. Docker Image Tags for Docker Hub

```
rajabhishekcommit/node-assignment:1.0
│                    │               │
│                    │               └── Version tag
│                    └── Repository name
└── Docker Hub username
```

- Tag = Address label on a package
- Must match your Docker Hub username EXACTLY
- Lowercase only!

---

### 5. Full Docker Lifecycle

```
Write Dockerfile → Build Image → Run Container → Test → Push to Hub → Delete Local → Pull & Run
```

---

## 📋 COMPLETE COMMANDS REFERENCE

### Build:
```bash
docker build -t node-assignment .
```

### Run:
```bash
docker run -d -p 80:3000 --name node-app node-assignment
```

### Test:
```bash
docker ps
docker logs node-app
curl http://localhost
# Browser: http://localhost
```

### Tag for Docker Hub:
```bash
docker tag node-assignment rajabhishekcommit/node-assignment:1.0
```

### Push:
```bash
docker login
docker push rajabhishekcommit/node-assignment:1.0
```

### Clean up:
```bash
docker rm -f node-app
docker rmi rajabhishekcommit/node-assignment:1.0
docker rmi node-assignment
```

### Pull and run from Docker Hub:
```bash
docker run -d -p 80:3000 --name node-app rajabhishekcommit/node-assignment:1.0
```

---

## 🐛 PROBLEMS SOLVED

### Problem 1: Wrong Image Name
**Mistake:** `FROM Nodejs:latest`
**Fix:** `FROM node:6-alpine`
**Lesson:** Docker images are ALWAYS lowercase. Pin specific versions!

### Problem 2: Wrong Port Number
**Mistake:** `EXPOSE 3030`
**Fix:** `EXPOSE 3000`
**Lesson:** Check the app code (bin/www) to find the actual port!

### Problem 3: Typo in WORKDIR
**Mistake:** `WORKDIR /usr/scr/app`
**Fix:** `WORKDIR /usr/src/app`
**Lesson:** src = source. Proofread paths carefully!

### Problem 4: npm ECONNREFUSED
**Error:** `connect ECONNREFUSED 104.16.11.34:443`
**Cause:** Network issue - npm couldn't reach registry
**Fix:** Retried the build and it worked
**Lesson:** Network errors are often temporary. Try again!

### Problem 5: Push Access Denied
**Error:** `push access denied, repository does not exist`
**Cause:** Not logged in / wrong username
**Fix:** `docker login` first, then use correct username
**Lesson:** Always login before pushing. Username must be exact!

### Problem 6: Repository Name Must Be Lowercase
**Error:** `repository name must be lowercase`
**Cause:** Used `RAJABHISHEK` (uppercase)
**Fix:** Used `rajabhishekcommit` (lowercase)
**Lesson:** Docker Hub usernames/repos are always lowercase!

---

## 🎯 DOCKERFILE INSTRUCTIONS USED

| Instruction | Purpose | Example |
|-------------|---------|---------|
| FROM | Base image | `FROM node:6-alpine` |
| RUN | Execute commands during build | `RUN apk add tini` |
| WORKDIR | Set working directory | `WORKDIR /usr/src/app` |
| COPY | Copy files from host to container | `COPY package.json ./` |
| EXPOSE | Document port | `EXPOSE 3000` |
| ENTRYPOINT | Always-running command | `ENTRYPOINT ["/sbin/tini", "--"]` |
| CMD | Default command/arguments | `CMD ["node", "./bin/www"]` |

---

## 🎯 ASSIGNMENT CHECKLIST

- ✅ Took existing Node.js app
- ✅ Created Dockerfile from scratch
- ✅ Built the image
- ✅ Tested the image (http://localhost → "Captain's Applause!")
- ✅ Pushed to Docker Hub (rajabhishekcommit/node-assignment:1.0)
- ✅ Removed local image and container
- ✅ Pulled from Docker Hub and ran again
- ✅ Iterative fixes (6 problems solved!)

---

## 🤯 COOL FACTS

1. **Layer sharing:** When pushing, Docker said "Mounted from library/node" - it reused existing layers from Docker Hub instead of uploading them again!
2. **Alpine is TINY:** node:6-alpine = 50MB vs node:6 = 660MB (92% smaller!)
3. **tini is only 23KB** but prevents zombie processes that can crash containers
4. **npm cache** can be 50-100MB - cleaning it saves significant space
5. **Build context** (446.5KB) = ALL files Docker sends to the daemon before building
6. **JSON array CMD** avoids shell wrapping, so signals reach your app properly

---

## 📚 SOURCES

- Bret Fisher's Docker Mastery Course - Dockerfile Assignment 1
- *Docker Deep Dive 2023* - Pages 71, 76, 89
- *Docker in Practice (2nd Edition)* - Page 76
- *Learn Docker in a Month of Lunches 2ed 2025* - Pages 142, 224
- *Docker Orchestration.pdf* - Page 49
- Docker Official Documentation - Best Practices

---

**Created:** March 2, 2026
**Status:** ✅ COMPLETE
**Time Invested:** ~4 hours
**Knowledge Gained:** Full Docker lifecycle mastery! 🐳

**Peter's Wisdom:** "Dockerfile is just a recipe! FROM is the base, RUN adds ingredients, COPY brings your stuff, EXPOSE puts up a sign, and CMD turns on the oven! Hehehehe!" 🍺
