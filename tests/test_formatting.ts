// ============================================================================
// 🧪 BÀI TEST 2: AUTO-FORMATTING (CONFORM.NVIM) & DIAGNOSTICS (TROUBLE.NVIM)
// ============================================================================
// Mở file này bằng Neovim: nvim /etc/nixos/tests/test_formatting.ts
// ============================================================================

// BƯỚC 1: TEST AUTO-FORMAT ON SAVE VỚI CONFORM.NVIM (PRETTIERD)
// Hướng dẫn:
// Đoạn code bên dưới bị thụt lề lộn xộn, dấu nháy không chuẩn.
// Hãy thử gõ lệnh `:w` hoặc bấm phím `<leader>lf` (Space + l + f):
// Toàn bộ đoạn code bên dưới sẽ tự động được format thẳng hàng, đẹp mắt ngay tức thì!

interface UserProfile {
  id: number;
  username: string;
  email: string;
  isActive: boolean;
}

const messyObject: UserProfile = {
  id: 1,
  username: "nixos_user",
  email: "user@nixos.org",
  isActive: true,
};

function calculateTotal(items: { price: number; quantity: number }[]): number {
  return items.reduce((acc, item) => {
    return acc + item.price * item.quantity;
  }, 0);
}

// BƯỚC 2: TEST TROUBLE.NVIM & LSP DIAGNOSTICS
// Dưới đây là 1 đoạn code cố tình có lỗi type để LSP bắt lỗi:
// Hướng dẫn:
// 1. Bấm phím `<leader>xx` (Space + x + x) để mở danh sách lỗi Trouble bên dưới màn hình!
// 2. Bấm phím `j`/`k` để di chuyển giữa các lỗi và bấm `<CR>` để nhảy tới dòng lỗi.
// 3. Bấm `<leader>xx` lần nữa để đóng bảng lỗi.

const wrongType: number = "Đây là chuỗi chứ không phải số";

// BƯỚC 3: TEST SYMBOLS VỚI TROUBLE
// Hướng dẫn: Bấm phím `<leader>cs` (Space + c + s) để xem danh sách toàn bộ Interface, Function, Variable trong file này!
