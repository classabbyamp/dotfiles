// This function gets your whole document as its `body`
// and formats it as a simple letter.
#let letter(  
  // The letter's sender, which is display at the top of the page.
  sender: none,

  // The letter's recipient, which is displayed close to the top.
  recipient: none,

  // The date, displayed to the right.
  date: none,

  // The subject line.
  subject: none,

  // The complimentary closing.
  closing: "Sincerely,",

  // Leave space for a signature
  sign: true,

  // The name with which the letter closes.
  name: none,

  // ps/enclosures that come after.
  ps: none,

  encl: none,

  // The letter's content.
  body
) = {
  // Configure page and text properties.
  set page(margin: (top: 1in, bottom: 1in, left: 1.25in, right: 1.25in))
  set par(justify: true)
  show par: set block(spacing: 1.2em)

  set text(font: "Linux Libertine",
  size: 11pt)

  // Give more margin on first page of letter
  v(0.75in)
  
  // Display sender at top of page. If there's no sender
  // add some hidden text to keep the same spacing.

  align(right,
    box({
      if sender != none {
        sender
      } else {
        // Give a little spacing to maintain visuals if sender address is not present.
        v(2em)
      }
      
      v(1em)
    
        date
    })
  )

  v(1em)


  // Display recipient.
  recipient


  v(1em)

  // Add the subject line, if any.
  if subject != none {
    pad(right: 10%, strong(subject))
  }

  body

  v(1em)

  grid(
  columns: (50%, auto),
  rows: (auto, auto),
  [],
  {    
    align(left, closing)

    if (sign) {
      v(4em)
    }

    align(left, name)
  }
  )

  if (ps != none or encl != none) {
    v(1em)
  } 

  if ps != none {
    linebreak()
    ps
  }

  if encl != none {
    linebreak()
    text[Enclosures:]

    set list(marker: "", indent: 1em, body-indent: 0pt,)
    for phase in encl [- #phase]
  }
  
}
