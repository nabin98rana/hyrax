# Copied from Curate
module CurationConcerns
   module WithGenericFiles
    extend ActiveSupport::Concern

    included do
      # The generic_files method comes from Hydra::Works::AggregatesGenericFiles
      # has_many :generic_files, predicate: ActiveFedora::RDF::Fcrepo::RelsExt.isPartOf, class_name: "CurationConcerns::GenericFile", inverse_of: :batch
      before_destroy :before_destroy_cleanup_generic_files
    end

    # Stopgap unil ActiveFedora ContainerAssociation includes an *_ids accessor.
    # At the moment, this is no more efficient than calling generic_files, but hopefully that will change in the future.
    def generic_file_ids
      generic_files.map { |generic_file| generic_file.id }
    end

    def before_destroy_cleanup_generic_files
      generic_files.each(&:destroy)
    end

    def copy_visibility_to_files
      generic_files.each do |gf|
        gf.visibility = visibility
        gf.save!
      end
    end

  end
end
