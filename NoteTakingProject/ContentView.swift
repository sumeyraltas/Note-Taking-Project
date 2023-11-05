import SwiftUI

struct ContentView: View {
    @State private var notes: [Note] = []
    @State private var isAddingNote = false
    @State private var newNoteTitle = ""
    @State private var mainTitle = "MY NOTES"
    @State private var newNoteContent = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(notes.indices, id: \.self) { index in
                    NavigationLink(destination: NoteDetail(note: $notes[index])) {
                        Text(notes[index].title)
                            .foregroundColor(.black)
                    }
                }
                .onDelete(perform: deleteNote)
            }
            .navigationBarItems(
                trailing:
                HStack {
                    Button(action: {
                        isAddingNote = true
                    }) {
                        Image(systemName: "plus")
                    }
                    EditButton()
                }
            )
            .navigationBarTitle(mainTitle)
            .background(Color.white)
        }
        .sheet(isPresented: $isAddingNote) {
            NavigationView {
                Form {
                    Section(header: Text("New Note")) {
                        TextField("Title", text: $newNoteTitle)
                        TextEditor(text: $newNoteContent)
                    }
                }
                .navigationBarTitle("Add Note")
                .navigationBarItems(leading:
                    Button("Cancel") {
                        isAddingNote = false
                    },
                    trailing:
                    Button("Save") {
                        let newNote = Note(title: newNoteTitle, content: newNoteContent)
                        notes.append(newNote)
                        isAddingNote = false
                        newNoteTitle = ""
                        newNoteContent = ""
                    }
                )
            }
        }
    }

    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Note: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var content: String
}
struct NoteDetail: View {
    @Binding var note: Note
    @State private var editedTitle = ""
    @State private var editedContent = ""

    var body: some View {
        VStack {
            TextField("Title", text: $editedTitle)
                .font(.system(size: 26, weight: .bold))
            TextEditor(text: $editedContent)
                .foregroundColor(.black)
        }
        .onAppear {
            editedTitle = note.title
            editedContent = note.content
        }
        .navigationBarItems(trailing:
            Button("Save") {
                note.title = editedTitle
                note.content = editedContent
            }
        )
    }
}

