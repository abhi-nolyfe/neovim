local helpers = require('test.functional.helpers')(after_each)
local clear, nvim, eq, assert_alive = helpers.clear, helpers.nvim, helpers.eq, helpers.assert_alive

describe('sign', function()
  before_each(clear)
  describe('unplace {id}', function()
    describe('without specifying buffer', function()
      it('deletes the sign from all buffers', function()
        -- place a sign with id 34 to first buffer
        nvim('command', 'sign define Foo text=+ texthl=Delimiter linehl=Comment numhl=Number')
        local buf1 = nvim('eval', 'bufnr("%")')
        nvim('command', 'sign place 34 line=3 name=Foo buffer=' .. buf1)
        -- create a second buffer and place the sign on it as well
        nvim('command', 'new')
        local buf2 = nvim('eval', 'bufnr("%")')
        nvim('command', 'sign place 34 line=3 name=Foo buffer=' .. buf2)
        -- now unplace without specifying a buffer
        nvim('command', 'sign unplace 34')
        eq('--- Signs ---\n', nvim('exec', 'sign place buffer=' .. buf1, true))
        eq('--- Signs ---\n', nvim('exec', 'sign place buffer=' .. buf2, true))
      end)
    end)
  end)

  describe('define {id}', function()
    it('does not leak memory when specifying multiple times the same argument', function()
      nvim('command', 'sign define Foo culhl=Normal culhl=Normal')
      assert_alive()
    end)
  end)
end)
