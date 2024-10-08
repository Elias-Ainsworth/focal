use execute::command;
use std::{path::PathBuf, process::Stdio};

#[derive(Default)]
pub struct WfRecorder {
    monitor: String,
    audio: bool,
    video: PathBuf,
    filter: String,
}

impl WfRecorder {
    pub fn new(monitor: &str, video: PathBuf) -> Self {
        Self {
            monitor: monitor.to_string(),
            video,
            ..Default::default()
        }
    }

    pub const fn audio(mut self, audio: bool) -> Self {
        self.audio = audio;
        self
    }

    pub fn filter(mut self, filter: &str) -> Self {
        self.filter = filter.to_string();
        self
    }

    pub fn record(self) {
        let mut wfrecorder = command!("wf-recorder");

        if !self.filter.is_empty() {
            wfrecorder.arg("--filter").arg(&self.filter);
        }

        if self.audio {
            wfrecorder.arg("--audio");
        }

        wfrecorder
            .arg("--output")
            .arg(&self.monitor)
            .arg("--overwrite")
            .arg("-f")
            .arg(&self.video)
            .stdout(Stdio::inherit())
            .stderr(Stdio::inherit())
            .spawn()
            .expect("failed to spawn wf-recorder");
    }
}
