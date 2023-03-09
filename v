Copy code
const canvas = document.getElementById("canvas");
const ctx = canvas.getContext("2d");

const SCREEN_WIDTH = 288;
const SCREEN_HEIGHT = 512;
const PIPE_GAP = 100;
const PIPE_SPEED = -4;
const GRAVITY = 0.2;
const BIRD_SPEED = -6;
const JUMP_SPEED = -6;
const FONT_SIZE = 36;
const FONT_COLOR = "#ffffff";

const birdImg = new Image();
birdImg.src = "bird.png";

const pipeImg = new Image();
pipeImg.src = "pipe.png";

const backgroundImg = new Image();
backgroundImg.src = "background.png";

const font = `${FONT_SIZE}px Arial`;

class Bird {
  constructor() {
    this.x = 50;
    this.y = SCREEN_HEIGHT / 2;
    this.velocity = 0;
    this.image = birdImg;
    this.width = birdImg.width;
    this.height = birdImg.height;
  }

  update() {
    this.velocity += GRAVITY;
    this.y += this.velocity;
  }

  jump() {
    this.velocity = JUMP_SPEED;
  }

  draw() {
    ctx.drawImage(this.image, this.x, this.y);
  }

  get rect() {
    return {
      x: this.x,
      y: this.y,
      width: this.width,
      height: this.height
    };
  }
}

class Pipe {
  constructor(x) {
    this.x = x;
    this.height = Math.floor(Math.random() * 201) + 100;
    this.top = 0;
    this.bottom = this.height + PIPE_GAP;
    this.image = pipeImg;
    this.width = pipeImg.width;
    this.topRect = {
      x: this.x,
      y: this.height,
      width: this.width,
      height: this.image.height
    };
    this.bottomRect = {
      x: this.x,
      y: this.bottom,
      width: this.width,
      height: this.image.height
    };
  }

  update() {
    this.x += PIPE_SPEED;
    this.topRect.x = this.x;
    this.bottomRect.x = this.x;
  }

  draw() {
    ctx.drawImage(this.image, this.topRect.x, this.topRect.y);
    ctx.save();
    ctx.translate(0, canvas.height);
    ctx.scale(1, -1);
    ctx.drawImage(this.image, this.bottomRect.x, canvas.height - this.bottomRect.y - this.image.height);
    ctx.restore();
  }

  get rect() {
    return [
      this.topRect,
      this.bottomRect
    ];
  }

  get isOffScreen() {
    return this.x < -this.width;
  }
}

class Game {
  constructor() {
    this.bird = new Bird();
    this.pipes = [];
    this.score = 0;
    this.running = true;
  }

  handleEvents() {
    canvas.addEventListener("mousedown", this.bird.jump.bind(this.bird));
    canvas.addEventListener("touchstart", this.bird.jump.bind(this.bird));
  }

  update() {
    this.bird.update();
    for (let i = 0; i < this.pipes.length; i++) {
      this.pipes[i].update();
      if (this.pipes[i].isOffScreen) {
        this.pipes.splice(i, 1);
        this.score++;
      }
    }
    if (this.pipes.length < 3) {
      this.pipes.push(new Pipe(SCREEN_WIDTH + PIPE_GAP));
    }
    if (this.bird.y > SCREEN_HEIGHT || this.bird.y < 0) {
