defmodule Dial9.DialView do
  import ExTwiml

  @spec render_view(String.t) :: String.t
  def render_view(phone_num) do
    twiml do
      dial do
        number phone_num
      end
    end
  end
end
