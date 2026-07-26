// =====================================================
// SOUTH BRONX - MULTI FRAM CHIPS MARSHMELLOW CARD
// Dark Green Edition (Console Version)
// =====================================================

const SouthBronxGame = {
    // ---- KONFIGURASI ----
    config: {
        background: '\x1b[42m\x1b[30m', // hijau tua (background)
        reset: '\x1b[0m',
        framCount: 3,
        maxChips: 100,
        marshmallowCards: ['🍬', '🍫', '🍭', '🍮', '🧁']
    },

    // ---- STATE ----
    state: {
        fram: 1,
        chips: 50,
        marshHand: [],
        deck: [],
        score: 0,
        turn: 1,
        isGameOver: false
    },

    // ---- INIT ----
    init() {
        this.state.chips = 50;
        this.state.fram = 1;
        this.state.score = 0;
        this.state.turn = 1;
        this.state.isGameOver = false;
        this.state.marshHand = [];
        this.state.deck = this._buildDeck();
        this._drawMarsh(3);
        this._render();
        return this;
    },

    _buildDeck() {
        const deck = [];
        const suits = ['♠', '♥', '♦', '♣'];
        const values = ['2','3','4','5','6','7','8','9','10','J','Q','K','A'];
        for (let s of suits) {
            for (let v of values) {
                deck.push({ suit: s, value: v, points: this._getPoints(v) });
            }
        }
        return this._shuffle(deck);
    },

    _getPoints(val) {
        if (val === 'A') return 11;
        if (['J','Q','K'].includes(val)) return 10;
        return parseInt(val);
    },

    _shuffle(arr) {
        for (let i = arr.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [arr[i], arr[j]] = [arr[j], arr[i]];
        }
        return arr;
    },

    _drawMarsh(count) {
        const marshPool = this.config.marshmallowCards;
        for (let i = 0; i < count; i++) {
            const rand = marshPool[Math.floor(Math.random() * marshPool.length)];
            this.state.marshHand.push(rand);
        }
    },

    // ---- GAME MECHANICS ----
    drawCard() {
        if (this.state.deck.length === 0) {
            this.state.deck = this._buildDeck();
        }
        return this.state.deck.pop();
    },

    playTurn(action, bet = 10) {
        if (this.state.isGameOver) {
            this._log('⚠️ GAME OVER! Reset dulu dengan .reset()');
            return this;
        }

        const card = this.drawCard();
        const isWin = Math.random() > 0.45; // 55% chance menang

        this._log(`\n--- TURN ${this.state.turn} ---`);
        this._log(`🎴 Kartu: ${card.suit}${card.value} (${card.points} pts)`);

        // Multi Fram mechanic
        const framMultiplier = this.state.fram;
        const basePoints = card.points * framMultiplier;

        if (isWin) {
            const reward = Math.floor(basePoints * (bet / 10)) + 5;
            this.state.chips += reward;
            this.state.score += reward;
            this.state.fram = Math.min(this.state.fram + 1, this.config.framCount);
            this._log(`✅ MENANG! +${reward} CHIP (fram x${framMultiplier})`);
            this._log(`🍬 Marshmallow bonus: ${this.state.marshHand.join(' ')}`);
        } else {
            const penalty = Math.floor(bet * 0.8) + 3;
            this.state.chips -= penalty;
            this.state.fram = Math.max(1, this.state.fram - 1);
            this._log(`❌ KALAH! -${penalty} CHIP (fram turun ke ${this.state.fram})`);
        }

        // Marshmallow card effect (random)
        if (Math.random() > 0.7 && this.state.marshHand.length > 0) {
            const marshUsed = this.state.marshHand.pop();
            const bonus = Math.floor(Math.random() * 15) + 5;
            this.state.chips += bonus;
            this._log(`✨ MARSHMELLOW "${marshUsed}" aktif! +${bonus} CHIP`);
        }

        // Check game over
        if (this.state.chips <= 0) {
            this.state.isGameOver = true;
            this.state.chips = 0;
            this._log('💀 GAME OVER - Chip habis!');
        }

        this.state.turn++;
        this._render();
        return this;
    },

    // ---- RESET ----
    reset() {
        this.init();
        this._log('🔄 Game di-reset!');
        return this;
    },

    // ---- RENDER (console dengan warna hijau tua) ----
    _render() {
        const bg = '\x1b[42m\x1b[30m'; // hijau tua
        const reset = '\x1b[0m';
        const bold = '\x1b[1m';
        const darkGreenBg = '\x1b[48;5;22m\x1b[37m'; // dark green background

        console.clear();
        console.log(`${darkGreenBg}${'═'.repeat(50)}${reset}`);
        console.log(`${darkGreenBg}  🏆 SOUTH BRONX · MULTI FRAM  ${reset}`);
        console.log(`${darkGreenBg}  🍬 MARSHMELLOW CARD EDITION   ${reset}`);
        console.log(`${darkGreenBg}${'═'.repeat(50)}${reset}`);
        console.log(`${darkGreenBg}  FRAM : ${this.state.fram}/${this.config.framCount}  |  TURN : ${this.state.turn}${reset}`);
        console.log(`${darkGreenBg}  CHIPS: ${'🪙'.repeat(Math.min(this.state.chips, 20))} ${this.state.chips}${reset}`);
        console.log(`${darkGreenBg}  SCORE: ${this.state.score} pts${reset}`);
        console.log(`${darkGreenBg}  MARSH: ${this.state.marshHand.length > 0 ? this.state.marshHand.join(' ') : '❌ habis'}${reset}`);
        console.log(`${darkGreenBg}  DECK : ${this.state.deck.length} kartu${reset}`);
        console.log(`${darkGreenBg}${'═'.repeat(50)}${reset}`);
        console.log(`${darkGreenBg}  [P] Play  |  [R] Reset  |  [Q] Quit${reset}`);
        console.log(`${darkGreenBg}${'═'.repeat(50)}${reset}`);
    },

    _log(msg) {
        const bg = '\x1b[42m\x1b[30m';
        const reset = '\x1b[0m';
        console.log(`${bg} ${msg} ${reset}`);
    }
};

// =====================================================
// PLAYGROUND - Jalankan di console/terminal
// =====================================================

// Inisialisasi game
const game = SouthBronxGame.init();

// ---- Contoh simulasi 5 turn otomatis ----
function autoPlay(rounds = 5) {
    for (let i = 0; i < rounds; i++) {
        if (game.state.isGameOver) break;
        const bet = Math.floor(Math.random() * 20) + 5;
        game.playTurn('auto', bet);
        // jeda biar keliatan (di browser/terminal)
        if (typeof window !== 'undefined') {
            // di browser pake alert atau setTimeout
        }
    }
}

// ---- EKSPOR FUNGSI UNTUK INTERAKSI MANUAL ----
// Di terminal/nodejs, jalankan:
// game.playTurn('manual', 15)   -> main dengan taruhan 15
// game.reset()                  -> reset game
// autoPlay(10)                  -> auto 10 turn

// ---- Contoh penggunaan interaktif (Node.js readline) ----
if (typeof require !== 'undefined' && require.main === module) {
    const readline = require('readline');
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    function prompt() {
        rl.question('\x1b[42m\x1b[30m Masukkan taruhan (atau r=reset, q=quit): \x1b[0m', (input) => {
            if (input.toLowerCase() === 'q') {
                console.log('\x1b[42m\x1b[30m Terima kasih! \x1b[0m');
                rl.close();
                return;
            }
            if (input.toLowerCase() === 'r') {
                game.reset();
                prompt();
                return;
            }
            const bet = parseInt(input);
            if (isNaN(bet) || bet < 1) {
                console.log('\x1b[41m\x1b[37m Taruhan harus angka > 0! \x1b[0m');
                prompt();
                return;
            }
            game.playTurn('manual', bet);
            if (game.state.isGameOver) {
                console.log('\x1b[41m\x1b[37m GAME OVER! Ketik r untuk reset \x1b[0m');
                prompt();
            } else {
                prompt();
            }
        });
    }

    console.log('\x1b[42m\x1b[30m 🎮 SOUTH BRONX MULTI FRAM CHIPS MARSHMELLOW \x1b[0m');
    prompt();
}

// === EKSPOR UNTUK MODULE ===
if (typeof module !== 'undefined') {
    module.exports = SouthBronxGame;
}