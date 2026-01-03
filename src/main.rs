use iced::widget::{Column, text};
use iced::{Element, Settings};

fn main() -> iced::Result {
    iced::run(Icarus::update, Icarus::view)
}

#[derive(Debug, Clone)]
enum Message {
    ButtonPressed,
}

#[derive(Default)]
struct TextBuffer {
    lines: Vec<String>,
}

impl TextBuffer {
    fn new() -> Self {
        let lines = vec!["Hello".to_string(), "world".to_string()];
        Self { lines }
    }

    fn to_column(&self) -> Column<'_, Message> {
        let elements: Vec<Element<'_, Message>> =
            self.lines.iter().map(|s| text(s).into()).collect();
        Column::with_children(elements)
    }
}

struct Icarus {
    buffer: TextBuffer,
}

impl Default for Icarus {
    fn default() -> Self {
        Self {
            buffer: TextBuffer::new(),
        }
    }
}

impl Icarus {
    fn update(&mut self, message: Message) {
        match message {
            Message::ButtonPressed => todo!(),
        }
    }

    fn view(&self) -> Element<Message> {
        self.buffer.to_column().into()
    }
}
