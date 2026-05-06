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

app.get("/health", (req, res) => {
  res.status(200).send("OK");
});

app.get("/", async (req, res) => {
  try {
    const visitCount = await increaseVisitCount();
    const posts = await getPosts();

    res.render("index", {
      hostname,
      visitCount,
      posts
    });
  } catch (err) {
    console.error(err);
    res.status(500).send("Internal Server Error");
  }
});

app.post("/posts", async (req, res) => {
  try {
    const { title, author, content } = req.body;

    await createPost(title, author, content);

    res.redirect("/");
  } catch (err) {
    console.error(err);
    res.status(500).send("Failed to create post");
  }
});

app.post("/delete/:id", async (req, res) => {
  try {
    await deletePost(req.params.id);

    res.redirect("/");
  } catch (err) {
    console.error(err);
    res.status(500).send("Failed to delete post");
  }
});

app.listen(PORT, () => {
  console.log(`Node.js web server running on port ${PORT}`);
});