const express = require("express");
const os = require("os");
const path = require("path");

const { getPosts, createPost, deletePost } = require("./db");
const { increaseVisitCount } = require("./redis");

const app = express();
const PORT = process.env.PORT || 8080;
const hostname = os.hostname();

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, "public")));

// Kubernetes livenessProbe/readinessProbe에서 사용할 health check endpoint
app.get("/health", (req, res) => {
  res.status(200).send("OK");
});

async function renderBoard(req, res, message = "") {
  const visitCount = await increaseVisitCount();
  const posts = await getPosts();

  res.render("index", {
    hostname,
    visitCount,
    posts,
    message
  });
}

app.get("/", async (req, res) => {
  try {
    await renderBoard(req, res);
  } catch (err) {
    console.error(err);
    res.status(500).send("게시판 목록을 불러오는 중 오류가 발생했습니다.");
  }
});

app.post("/posts", async (req, res) => {
  try {
    const { title, author, content } = req.body;

    await createPost(title, author, content);
    await renderBoard(req, res, "게시글이 저장되었습니다.");
  } catch (err) {
    console.error(err);
    res.status(500).send("게시글 저장 중 오류가 발생했습니다.");
  }
});

app.post("/delete", async (req, res) => {
  try {
    await deletePost(req.body.id);
    await renderBoard(req, res, "게시글이 삭제되었습니다.");
  } catch (err) {
    console.error(err);
    res.status(500).send("게시글 삭제 중 오류가 발생했습니다.");
  }
});

// Kubernetes Service가 Pod 내부 서버에 접근할 수 있도록 0.0.0.0에 바인딩
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Node.js web server running on port ${PORT}`);
});
