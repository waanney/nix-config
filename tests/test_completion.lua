-- ============================================================================
-- 🧪 BÀI TEST 1: AUTO-COMPLETION & LSP VỚI BLINK.CMP & LAZYDEV
-- ============================================================================
-- Mở file này bằng Neovim: nvim /etc/nixos/tests/test_completion.lua
-- ============================================================================

-- BƯỚC 1: TEST GỢI Ý CỦA NEVOVIM API (LAZYDEV + BLINK.CMP)
-- Hướng dẫn: Xuống dòng dưới, gõ: `vim.api.nvim_` và xem popup gợi ý hiện ra tức thì.
-- Dùng phím <Tab> / <S-Tab> để chọn, bấm <CR> để chọn hàm.

local function test_api()
  -- Hãy thử gõ ở đây:
  -- vim.api.
end

-- BƯỚC 2: TEST GỢI Ý METHOD & LUA TYPES
-- Hướng dẫn: Đặt con trỏ vào cuối dòng bên dưới, gõ `message:` và xem các method của string:
local message = "Hello from NixOS"
-- message:

-- BƯỚC 3: TEST SNIPPET
-- Hướng dẫn:
-- 1. Xuống dòng mới và gõ chữ: `fun` rồi bấm <Tab> -> Luasnip/friendly-snippet sẽ tạo hàm mẫu.
-- 2. Bấm <Tab> tiếp để nhảy giữa tên hàm, tham số và thân hàm!


-- BƯỚC 4: TEST LSP HOVER & DOCUMENTATION
-- Hướng dẫn:
-- Đặt con trỏ vào từ `notify` ở dòng dưới và bấm phím `K` (viết hoa):
vim.notify("Blink.cmp and Lazydev are working perfectly!", vim.log.levels.INFO)

-- BƯỚC 5: TEST SIGNATURE HELP
-- Hướng dẫn: Đặt con trỏ vào bên trong cặp ngoặc đơn của `print()` và bấm <C-k>:
print("test signature help")
