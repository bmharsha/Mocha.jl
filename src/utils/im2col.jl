function im2col(img, col, width, height, channels, kernel::NTuple{2,Int}, pad::NTuple{2,Int}, stride::NTuple{2,Int})
  kernel_w, kernel_h = kernel
  pad_w, pad_h = pad
  stride_w, stride_h = stride

  height_col = floorint((height + 2pad_h - kernel_h) / stride_h) + 1
  width_col = floorint((width + 2pad_w - kernel_w) / stride_w) + 1
  channels_col = channels * kernel_h * kernel_w

  for c = 0:channels_col-1
    w_offset = c % kernel_w
    h_offset = floorint(c / kernel_w) % kernel_h
    c_im = floorint(c / kernel_h / kernel_w) # channel
    for h = 0:height_col-1
      for w = 0:width_col-1
        h_pad = h*stride_h - pad_h + h_offset
        w_pad = w*stride_w - pad_w + w_offset
        if (h_pad >= 0 && h_pad < height && w_pad >= 0 && w_pad < width)
            col[1 + (c*height_col+h) * width_col + w] = 
                img[1 + (c_im * height + h_pad) * width + w_pad]
        else
          col[1 + (c*height_col+h) * width_col + w] = 0
        end
      end
    end
  end
end

function col2im(col, img, width, height, channels, kernel::NTuple{2,Int}, pad::NTuple{2,Int}, stride::NTuple{2,Int})
  kernel_w, kernel_h = kernel
  pad_w, pad_h = pad
  stride_w, stride_h = stride

  height_col = floorint((height + 2pad_h - kernel_h) / stride_h) + 1
  width_col = floorint((width + 2pad_w - kernel_w) / stride_w) + 1
  channels_col = channels * kernel_h * kernel_w

  fill!(img, 0)
  for c = 0:channels_col-1
    w_offset = c % kernel_w
    h_offset = floorint(c / kernel_w) % kernel_h
    c_im = floorint(c / kernel_w / kernel_h)
    for h = 0:height_col-1
      for w = 0:width_col-1
        h_pad = h * stride_h - pad_h + h_offset
        w_pad = w * stride_w - pad_w + w_offset
        if h_pad >= 0 && h_pad < height && w_pad >= 0 && w_pad < width
          img[1 + (c_im * height + h_pad) * width + w_pad] +=
              col[1 + (c * height_col + h) * width_col + w]
        end
      end
    end
  end
end
