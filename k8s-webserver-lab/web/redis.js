const Redis = require("ioredis");

const redis = new Redis({
  // Docker Compose: redis
  // Kubernetes: redis-service
  host: process.env.REDIS_HOST || "redis-service",
  port: process.env.REDIS_PORT || 6379
});

async function increaseVisitCount() {
  return await redis.incr("visit_count");
}

module.exports = {
  increaseVisitCount
};
