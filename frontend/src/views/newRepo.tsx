import { FunctionComponent } from "preact";
import { useState } from "preact/hooks";
import { Button } from "../components/button";
import { Card } from "../components/card";
import { Header } from "../components/header";
import { Select } from "../components/select";
import { TextField } from "../components/textField";

const NewRepo: FunctionComponent = () => {
  const [name, setName] = useState("");
  const [fullPath, setFullPath] = useState("");
  const [directory, setDirectory] = useState("");

  return (
    <>
      <Header title="new repo" />
      <Card footer={<Button>Create</Button>}>
        <div class="grid grid-cols-6 gap-6">
          <TextField
            id="name"
            label="Name"
            class="col-span-3"
            value={name}
            onInput={(e) => setName((e.target as HTMLInputElement).value)}
          />
          <TextField
            id="full_path"
            label="Full Path"
            class="col-span-3"
            value={fullPath}
            onInput={(e) => setFullPath((e.target as HTMLInputElement).value)}
          />
          <TextField
            id="directory"
            label="Directory"
            class="col-span-3"
            value={directory}
            onInput={(e) => setDirectory((e.target as HTMLInputElement).value)}
          />
          <div class="col-span-3">
            <Select label="Host" />
          </div>
        </div>
      </Card>
    </>
  );
};

export { NewRepo };
