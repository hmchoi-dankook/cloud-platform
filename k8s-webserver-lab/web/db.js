const { Pool } = require("pg");

const pool = new Pool({
  // Docker Compose: postgres
  // Kubernetes: postgres-service
  host: process.env.POSTGRES_HOST || "postgres-service",
  port: process.env.POSTGRES_PORT || 5432,
  database: process.env.POSTGRES_DB || "appdb",
  user: process.env.POSTGRES_USER || "appuser",
  password: process.env.POSTGRES_PASSWORD || "apppassword"
});

async function getPosts() {
  const result = await pool.query(`
    SELECT id, title, author, content, created_at
    FROM posts
    ORDER BY id DESC
  `);

  return result.rows;
}

async function createPost(title, author, content) {
  await pool.query(
    "INSERT INTO posts(title, author, content) VALUES($1, $2, $3)",
    [title, author, content]
  );
}

async function deletePost(id) {
  await pool.query(
    "DELETE FROM posts WHERE id = $1",
    [id]
  );
}

module.exports = {
  getPosts,
  createPost,
  deletePost
};
