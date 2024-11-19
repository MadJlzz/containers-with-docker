package main

import (
	"fmt"
	"os"

	yaml "sigs.k8s.io/yaml/goyaml.v3"
)

const defaultCfgFilepath = "configs/app.yml"

type AppConfiguration struct {
	Server ServerConfiguration
}

type ServerConfiguration struct {
	Port int `yaml:"port"`
}

func NewConfiguration() (*AppConfiguration, error) {
	cfgFilepath, ok := os.LookupEnv("APP_CONFIGURATION_FILE")
	if !ok {
		cfgFilepath = defaultCfgFilepath
	}

	f, err := os.ReadFile(cfgFilepath)
	if err != nil {
		return nil, fmt.Errorf("config.go: cannot read config file. got: %w\n", err)
	}

	var cfg AppConfiguration
	err = yaml.Unmarshal(f, &cfg)
	if err != nil {
		return nil, fmt.Errorf("config.go: cannot unmarshal config file to struct. got: %w\n", err)
	}

	return &cfg, nil
}
